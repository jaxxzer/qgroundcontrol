/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#ifndef RallyPointManager_H
#define RallyPointManager_H

#include <QObject>
#include <QGeoCoordinate>

#include "QGCLoggingCategory.h"

class Vehicle;

Q_DECLARE_LOGGING_CATEGORY(RallyPointManagerLog)

/// This is the base class for firmware specific rally point managers. A rally point manager is responsible
/// for communicating with the vehicle to set/get rally points.
class RallyPointManager : public QObject
{
    Q_OBJECT
    
public:
    RallyPointManager(Vehicle* vehicle);
    ~RallyPointManager();
    
    /// Returns true if the manager is currently communicating with the vehicle
    virtual bool inProgress(void) const { return false; }

    /// Load the current settings from the vehicle
    ///     Signals loadComplete when done
    virtual void loadFromVehicle(void);

    /// Send the current settings to the vehicle
    ///     Signals sendComplete when done
    virtual void sendToVehicle(const QList<QGeoCoordinate>& rgPoints);

    /// Remove all rally points from the vehicle
    ///     Signals removeAllCompleted when done
    virtual void removeAll(void);

    virtual bool rallyPointsSupported(void) const { return false; }

    QList<QGeoCoordinate> points(void) const { return _rgPoints; }

    virtual QString editorQml(void) const { return QStringLiteral("qrc:/FirmwarePlugin/RallyPointEditor.qml"); }

    /// Error codes returned in error signal
    typedef enum {
        InternalError,
        TooFewPoints,           ///< Too few points for valid geofence
        TooManyPoints,          ///< Too many points for valid geofence
        InvalidCircleRadius,
    } ErrorCode_t;
    
signals:
    void loadComplete       (const QList<QGeoCoordinate> rgPoints);
    void inProgressChanged  (bool inProgress);
    void error              (int errorCode, const QString& errorMsg);
    void removeAllComplete  (void);
    void sendComplete       (void);

protected:
    void _sendError(ErrorCode_t errorCode, const QString& errorMsg);

    Vehicle*                _vehicle;
    QList<QGeoCoordinate>   _rgPoints;
};

#endif
