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

        if((tee = gst_element_factory_make("tee", "tee-guy")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('tee')";
            break;
        }

        if((queue1 = gst_element_factory_make("queue", "queue-guy")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('queue1')";
            break;
        }

        if((queue2 = gst_element_factory_make("queue", "queue2-guy")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('queue2')";
            break;
        }

        if((filesink = gst_element_factory_make("filesink", "filesink-guy")) == NULL)  {
            qCritical() << "VideoReceiver::start() failed. Error with gst_element_factory_make('filesink')";
            break;
        } else {
            g_object_set(G_OBJECT(filesink), "location", "/home/jack/qgcvideooutput.mp4", NULL);
        }

        if((mux = gst_element_factory_make("mp4mux", "mp4mux-guy")) == NULL)  {
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


        GstPadTemplate *tee_src_pad_template;
         GstPad *tee_q1_pad, *tee_q2_pad;
           GstPad *q1_pad, *q2_pad;

         /* Manually link the Tee, which has "Request" pads */
         if ( !(tee_src_pad_template = gst_element_class_get_pad_template (GST_ELEMENT_GET_CLASS (tee), "src_%u"))) {
          gst_object_unref (_pipeline);
          qCritical() << "Unable to get pad template";
         }

         /* Obtaining request pads for the tee elements*/
         tee_q1_pad = gst_element_request_pad (tee, tee_src_pad_template, NULL, NULL);
         g_print ("Obtained request pad %s for q1 branch.\n", gst_pad_get_name (tee_q1_pad));
         q1_pad = gst_element_get_static_pad (queue1, "sink");

         tee_q2_pad = gst_element_request_pad (tee, tee_src_pad_template, NULL, NULL);
         g_print ("Obtained request pad %s for q2 branch.\n", gst_pad_get_name (tee_q2_pad));
         q2_pad = gst_element_get_static_pad (queue2, "sink");


         /* Link the tee to the queue 1 */
         if (gst_pad_link(tee_q1_pad, q1_pad) != GST_PAD_LINK_OK ){

          qCritical() << "Tee for q1 could not be linked.\n";

         }

         /* Link the tee to the queue 2 */
         if (gst_pad_link (tee_q2_pad, q2_pad) != GST_PAD_LINK_OK) {

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

         if(gst_pad_link(q2_src, mux_video_sink) != GST_PAD_LINK_OK) {
             qCritical() << "failed to link q2 and mux";
         }


         gst_object_unref (q1_pad);
         gst_object_unref (q2_pad);

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
