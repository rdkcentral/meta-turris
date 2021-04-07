#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2019 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################


sleep 10

LIGHTTPD_PROCESS=`ps aux | grep lighttpd | grep -v grep | wc -l`

if [ $LIGHTTPD_PROCESS = 0 ]; then
        /bin/sh /etc/webgui.sh
else
        echo "Lighttpd process was already running"
        exit 0
fi
