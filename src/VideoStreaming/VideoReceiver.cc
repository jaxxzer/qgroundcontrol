/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/**
 * @file
 *   @brief QGC Video Receiver
 *   @author Gus Grubba <mavlink@grubba.com>
 */

#include "VideoReceiver.h"
#include <QDebug>
#include <QDir>

VideoReceiver::VideoReceiver(QObject* parent)
    : QObject(parent)
#if defined(QGC_GST_STREAMING)
    , _pipeline(NULL)
    , _videoSink(NULL)
#endif
{

}

VideoReceiver::~VideoReceiver()
{
#if defined(QGC_GST_STREAMING)
    EOS();
#endif
}

#if defined(QGC_GST_STREAMING)
void VideoReceiver::setVideoSink(GstElement* sink)
{
    if (_videoSink) {
        gst_object_unref(_videoSink);
        _videoSink = NULL;
    }
    if (sink) {
        _videoSink = sink;
        gst_object_ref_sink(_videoSink);
    }
}
#endif

#if defined(QGC_GST_STREAMING)
static void newPadCB(GstElement * element, GstPad* pad, gpointer data)
{
    gchar *name;
    name = gst_pad_get_name(pad);
    g_print("A new pad %s was created\n", name);
    GstCaps * p_caps = gst_pad_get_pad_template_caps (pad);
    gchar * description = gst_caps_to_string(p_caps);
    qDebug() << p_caps << ", " << description;
    g_free(description);
    GstElement * p_rtph264depay = GST_ELEMENT(data);
    if(gst_element_link_pads(element, name, p_rtph264depay, "sink") == false)
        qCritical() << "newPadCB : failed to link elements\n";
    g_free(name);
}
#endif

void VideoReceiver::start()
{
#if defined(QGC_GST_STREAMING)
    if (_uri.isEmpty()) {
        qCritical() << "VideoReceiver::start() failed because URI is not specified";
        return;
    }
    if (_videoSink == NULL) {
        qCritical() << "VideoReceiver::start() failed because video sink is not set";
        return;
    }

    stop();

    bool running = false;

    GstElement*     dataSource  = NULL;
    GstCaps*        caps        = NULL;
    GstElement*     demux       = NULL;
    GstElement*     parser      = NULL;
    GstElement*     decoder     = NULL;
    GstElement*     tee         = NULL;
    GstElement*     queue1      = NULL;
    GstElement*     queue2      = NULL;
    GstElement*     filesink    = NULL;
    GstElement*     mux         = NULL;

    bool isUdp = _uri.contains("udp://");

    do {
        if ((_pipeline = gst_pipeline_new("receiver")) == NULL) {
            qCritical() << "VideoReceiver::start() failed. Error with gst_pipeline_new()";
            break;
        }

        if(isUdp) {
            dataSource = gst_element_factory_make("udpsrc", "udp-source");
        } else {
            dataSource = gst_element_factory_make("rtspsrc", "rtsp-source");
        }

        if (!dataSource) {
            qCritical() << "VideoReceiver::start() failed. Error with data source for gst_element_factory_make()";
            break;
        }

        if(isUdp) {
            if ((caps = gst_caps_from_string("application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264")) == NULL) {
                qCritical() << "VideoReceiver::start() failed. Error with gst_caps_from_string()";
                break;
            }
            g_object_set(G_OBJECT(dataSource), "uri", qPrintable(_uri), "caps", caps, NULL);
        } else {
            g_object_set(G_OBJECT(dataSource), "location", qPrintable(_uri), "latency", 0, NULL);
        }

        if ((demux = gst_element_factory_make("rtph264depay", "rtp-h264-depacketizer")) == NULL) {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('rtph264depay')";
            break;
        }

        if(!isUdp) {
            g_signal_connect(dataSource, "pad-added", G_CALLBACK(newPadCB), demux);
        }

        if ((parser = gst_element_factory_make("h264parse", "h264-parser")) == NULL) {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('h264parse')";
            break;
        }

        if ((decoder = gst_element_factory_make("avdec_h264", "h264-decoder")) == NULL) {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('avdec_h264')";
            break;
        }

        if((tee = gst_element_factory_make("tee", "stream-file-tee")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('tee')";
            break;
        }

        if((queue1 = gst_element_factory_make("queue", "queue1")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('queue1')";
            break;
        }

        if((queue2 = gst_element_factory_make("queue", "queue2")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('queue2')";
            break;
        }

        if((filesink = gst_element_factory_make("filesink", "mp4-file")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('filesink')";
            break;
        } else {
            qCritical() << qPrintable(QString("%1/%2").arg(QDir::homePath()).arg("qgcvideooutput.mp4"));
            g_object_set(G_OBJECT(filesink), "location", qPrintable(QString("%1/%2").arg(QDir::homePath()).arg("qgcvideooutput.mp4")), NULL);
        }

        if((mux = gst_element_factory_make("mp4mux", "mp4-muxer")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('mp4mux')";
            break;
        }

        gst_bin_add_many(GST_BIN(_pipeline), dataSource, demux, parser, tee, queue1, decoder, _videoSink, queue2, mux, filesink, NULL);

//        if(isUdp) {
//            res = gst_element_link_many(dataSource, demux, parser, decoder, tee, _videoSink, NULL);
//        } else {
//            res = gst_element_link_many(demux, parser, decoder, tee, _videoSink, NULL);
//        }

        if(!gst_element_link_many(dataSource, demux, parser, tee, NULL)) {
            qCritical() << "unable to link datasource and tee";
            break;
        }

        if(!gst_element_link_many(queue1, decoder, _videoSink, NULL)) {
            qCritical() << "unable to link queue1 and videosink";
            break;
        }

        if(!gst_element_link_many(mux, filesink, NULL)) {
            qCritical() << "unable to link queue2 and filesink ";
           break;
        }

         GstPad *tee_src1, *tee_src2;
         GstPad *q1_sink, *q2_sink;

         tee_src1 = gst_element_get_request_pad(tee, "src_%u");
         q1_sink = gst_element_get_static_pad(queue1, "sink");

         tee_src2 = gst_element_get_request_pad(tee, "src_%u");
         q2_sink = gst_element_get_static_pad(queue2, "sink");


         // Link the tee to queue1
         if (gst_pad_link(tee_src1, q1_sink) != GST_PAD_LINK_OK ){
            qCritical() << "Tee for q1 could not be linked.\n";
         }

         // Link the tee to the queue2
         if (gst_pad_link (tee_src2, q2_sink) != GST_PAD_LINK_OK) {
            qCritical() << "Tee for q2 could not be linked.\n";
         }

         GstPad* mux_video_sink;
         if((mux_video_sink = gst_element_get_request_pad(mux, "video_%u")) == NULL) {
             qCritical() << "no mp4mux pad";
         }

         GstPad* q2_src;
         if((q2_src = gst_element_get_static_pad(queue2, "src")) == NULL) {
             qCritical() << "no q2 src pad";
         }

         // link queue2 and mp4 muxer
         if(gst_pad_link(q2_src, mux_video_sink) != GST_PAD_LINK_OK) {
             qCritical() << "failed to link q2 and mux";
         }

         gst_object_unref (tee_src1);
         gst_object_unref (tee_src2);
         gst_object_unref (q1_sink);
         gst_object_unref (q2_sink);
         gst_object_unref (q2_src);

        dataSource = demux = parser = decoder = NULL;

        GstBus* bus = NULL;

        if ((bus = gst_pipeline_get_bus(GST_PIPELINE(_pipeline))) != NULL) {
            gst_bus_add_watch(bus, _onBusMessage, this);
            gst_object_unref(bus);
            bus = NULL;
        }

        running = gst_element_set_state(_pipeline, GST_STATE_PLAYING) != GST_STATE_CHANGE_FAILURE;

    } while(0);

    if (caps != NULL) {
        gst_caps_unref(caps);
        caps = NULL;
    }

    if (!running) {
        qCritical() << "VideoReceiver::start() failed";

        if (decoder != NULL) {
            gst_object_unref(decoder);
            decoder = NULL;
        }

        if (parser != NULL) {
            gst_object_unref(parser);
            parser = NULL;
        }

        if (demux != NULL) {
            gst_object_unref(demux);
            demux = NULL;
        }

        if (dataSource != NULL) {
            gst_object_unref(dataSource);
            dataSource = NULL;
        }

        if (_pipeline != NULL) {
            gst_object_unref(_pipeline);
            _pipeline = NULL;
        }
    }
#endif
}


void VideoReceiver::EOS() {
    gst_element_send_event(_pipeline, gst_event_new_eos());
}

void VideoReceiver::stop()
{
#if defined(QGC_GST_STREAMING)
    if (_pipeline != NULL) {
        qCritical() << "stopping pipeline";

        gst_element_set_state(_pipeline, GST_STATE_NULL);
        gst_object_unref(_pipeline);
        _pipeline = NULL;
    }
#endif
}

void VideoReceiver::setUri(const QString & uri)
{
    stop();
    _uri = uri;
}

#if defined(QGC_GST_STREAMING)
void VideoReceiver::_onBusMessage(GstMessage* msg)
{
    switch (GST_MESSAGE_TYPE(msg)) {
    case GST_MESSAGE_EOS:
        qCritical() << "got eos";
        stop();
        break;
    case GST_MESSAGE_ERROR:
        do {
            gchar* debug;
            GError* error;
            gst_message_parse_error(msg, &error, &debug);
            g_free(debug);
            qCritical() << error->message;
            g_error_free(error);
        } while(0);
        stop();
        break;
    default:
        break;
    }
}
#endif

#if defined(QGC_GST_STREAMING)
gboolean VideoReceiver::_onBusMessage(GstBus* bus, GstMessage* msg, gpointer data)
{
    Q_UNUSED(bus)
    Q_ASSERT(msg != NULL && data != NULL);
    VideoReceiver* pThis = (VideoReceiver*)data;
    pThis->_onBusMessage(msg);
    return TRUE;
}
#endif
