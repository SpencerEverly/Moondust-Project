/*
 * Moondust, a free game engine for platform game making
 * Copyright (c) 2014-2023 Vitaly Novichkov <admin@wohlnet.ru>
 *
 * This software is licensed under a dual license system (MIT or GPL version 3 or later).
 * This means you are free to choose with which of both licenses (MIT or GPL version 3 or later)
 * you want to use this software.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * You can see text of MIT license in the LICENSE.mit file you can see in Engine folder,
 * or see https://mit-license.org/.
 *
 * You can see text of GPLv3 license in the LICENSE.gpl3 file you can see in Engine folder,
 * or see <http://www.gnu.org/licenses/>.
 */

#pragma once
#ifndef LUA_LOGGER_H
#define LUA_LOGGER_H

#include <string>

#include <luabind/luabind.hpp>
#include <lua_includes/lua.hpp>

class Binding_Core_GlobalFuncs_Logger
{
    public:
        static void debug(const std::string &msg);
        static void warning(const std::string &msg);
        static void critical(const std::string &msg);

        static luabind::scope bindToLua();

};

#endif // LUA_LOGGER_H
