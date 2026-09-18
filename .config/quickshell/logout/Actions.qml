pragma Singleton
import QtQuick

QtObject {
    enum Action {
        None,
        Shutdown,
        Suspend,
        Hibernate,
        Reboot
    }
}
