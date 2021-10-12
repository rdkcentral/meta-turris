DEPENDS_remove = "virtual/crypt"
DEPENDS_append = " nanomsg"
DEPENDS_append_broadband_dunfell = " libxcrypt"

SRC_URI_remove_extender = "file://ipc-event.patch"
SRC_URI_remove_extender = "file://ppp-remote-local-samelinklocaladdresses-fix.patch"
SRC_URI_remove_extender = "file://ppp-auth-retry_and_error-code.patch"
