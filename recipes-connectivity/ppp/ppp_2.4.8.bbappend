DEPENDS_remove = "virtual/crypt"
DEPENDS_append = " nanomsg"
DEPENDS_append_broadband_dunfell = " libxcrypt"

SRC_URI_remove_extender = "file://ipc-event.patch"
