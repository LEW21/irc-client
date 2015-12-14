# LEW21/irc-client
Simple IRC client using Qt Quick

![screenshot](https://raw.githubusercontent.com/LEW21/irc-client/master/screenshot.png)

This project really needs another name. Unfortunately, I've run out of names.

## Building and running
```sh
% qbs run
```

If you haven't used qbs on this computer before, you might need to configure it before building the project:
```sh
% qbs setup-toolchains --detect
% qbs setup-qt --detect
% qbs config defaultProfile qt-5-5-1 # use the Qt 5 profile detected by setup-qt here.
```

To run multiple instances on the same machine, you may execute the binary directly:
```sh
% qt-*/install-root/bin/net.lew21.irc-client
```

## License - GNU AGPLv3+
Copyright (C) 2015 Janusz Lewandowski

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
