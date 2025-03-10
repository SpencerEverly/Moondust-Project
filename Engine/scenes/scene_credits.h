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

#ifndef SCENE_CREDITS_H
#define SCENE_CREDITS_H

#include <vector>
#include <common_features/pge_texture.h>
#include <common_features/simple_animator.h>

#include "scene.h"

#include <script/lua_credits_engine.h>

class CreditsScene_misc_img
{
public:
    CreditsScene_misc_img();
    ~CreditsScene_misc_img();
    CreditsScene_misc_img(const CreditsScene_misc_img &im);

    int x;
    int y;
    PGE_Texture t;
    SimpleAnimator a;
    int frmH;
};

class CreditsScene : public Scene
{
public:
    CreditsScene();
    ~CreditsScene();
    void init();

    void setWaitTime(int time);
    void exitFromScene();

    void onKeyboardPressedSDL(SDL_Keycode sdl_key, Uint16 modifier);
    LuaEngine* getLuaEngine();
    void update();
    void render();
    int exec();

private:
    float _waitTimer;

    PGE_Texture background;
    PGEColor    bgcolor;
    std::vector<CreditsScene_misc_img > imgs;

    LuaCreditsEngine luaEngine;
};

#endif // SCENE_CREDITS_H
