/*
 * Platformer Game Engine by Wohlstand, a free platform for game making
 * Copyright (c) 2016 Vitaly Novichkov <admin@wohlnet.ru>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#include "util.h"
#include <QFileInfo>

#ifdef _WIN32
#include <windows.h>
#endif

static const std::basic_string<unsigned char> base64_chars =
    reinterpret_cast<const unsigned char *>(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz"
        "0123456789+/");

static inline bool is_base64(unsigned char c)
{
    return (isalnum(c) || (c == '+') || (c == '/'));
}

QString util::filePath(QString s)
{
    QString t = s;
    t.replace('\\', '_');
    t.replace('/', '_');
    t.replace(':', '_');
    t.replace('*', '_');
    t.replace('?', '_');
    t.replace('\"', '_');
    t.replace('<', '_');
    t.replace('>', '_');
    t.replace('|', '_');
    return t;
}

bool util::strempty(const char *str)
{
    if(str)
    {
        if(strlen(str))
            return true;
    }

    return false;
}

QString util::resolveRelativeOrAbsolute(const QString &path, const QStringList &relativeLookup)
{
    if(QFileInfo(path).isAbsolute())
    {
        if(QFileInfo(path).exists())
            return path;
    }
    else
    {
        foreach(QString nextpath, relativeLookup)
        {
            QString newCompletePath = nextpath + "/" + path;

            if(QFileInfo(newCompletePath).exists())
                return newCompletePath;
        }
    }

    return "";
}

template<class TList>
inline void CSV2IntArr_CODE(const QString &source, TList &dest, const typename TList::value_type &def)
{
    typedef typename TList::value_type T;

    if(!source.isEmpty())
    {
        bool ok;
        QStringList tmlL = source.split(',', QString::SkipEmptyParts);

        foreach(QString fr, tmlL)
        {
            if(std::is_same<T, int>::value)
                dest.push_back(fr.toInt(&ok));
            else
                dest.push_back(fr.toDouble(&ok));

            if(!ok) dest.pop_back();
        }

        if(dest.isEmpty()) dest.push_back(def);
    }
    else
        dest.push_back(def);
}

void util::CSV2IntArr(QString source, QList<int> &dest)
{
    CSV2IntArr_CODE(source, dest, 0);
}

void util::CSV2IntArr(QString source, QVector<int> &dest)
{
    CSV2IntArr_CODE(source, dest, 0);
}

void util::CSV2DoubleArr(QString source, QList<double> &dest)
{
    CSV2IntArr_CODE(source, dest, 0.0);
}

void util::CSV2DoubleArr(QString source, QVector<double> &dest)
{
    CSV2IntArr_CODE(source, dest, 0.0);
}

void util::base64_encode(std::string &ret, const unsigned char *bytes_to_encode, size_t in_len)
{
    int i = 0;
    int j = 0;
    unsigned char char_array_3[3];
    unsigned char char_array_4[4];

    while(in_len--)
    {
        char_array_3[i++] = *(bytes_to_encode++);

        if(i == 3)
        {
            char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
            char_array_4[1] = static_cast<unsigned char>(
                                  (static_cast<unsigned int>(char_array_3[0] & 0x03) << 4) +
                                  (static_cast<unsigned int>(char_array_3[1] & 0xf0) >> 4)
                              );
            char_array_4[2] = static_cast<unsigned char>(
                                  (static_cast<unsigned int>(char_array_3[1] & 0x0f) << 2) +
                                  (static_cast<unsigned int>(char_array_3[2] & 0xc0) >> 6)
                              );
            char_array_4[3] = char_array_3[2] & 0x3f;

            for(i = 0; (i < 4) ; i++)
                ret += static_cast<char>(base64_chars[char_array_4[i]]);

            i = 0;
        }
    }

    if(i)
    {
        for(j = i; j < 3; j++)
            char_array_3[j] = '\0';

        char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
        char_array_4[1] = static_cast<unsigned char>(
                              (static_cast<unsigned int>(char_array_3[0] & 0x03) << 4) +
                              (static_cast<unsigned int>(char_array_3[1] & 0xf0) >> 4)
                          );
        char_array_4[2] = static_cast<unsigned char>(
                              (static_cast<unsigned int>(char_array_3[1] & 0x0f) << 2) +
                              (static_cast<unsigned int>(char_array_3[2] & 0xc0) >> 6)
                          );
        char_array_4[3] = char_array_3[2] & 0x3f;

        for(j = 0; (j < i + 1); j++)
            ret += static_cast<char>(base64_chars[char_array_4[j]]);

        while((i++ < 3))
            ret += '=';
    }
}

void util::base64_decode(std::string &ret, const std::string &encoded_string)
{
    size_t in_len = encoded_string.size();
    int i = 0;
    int j = 0;
    size_t in_ = 0;
    unsigned char char_array_4[4], char_array_3[3];

    while(in_len-- && (encoded_string[in_] != '=') && is_base64(static_cast<unsigned char>(encoded_string[in_])))
    {
        char_array_4[i++] = static_cast<unsigned char>(encoded_string[in_]);
        in_++;

        if(i == 4)
        {
            for(i = 0; i < 4; i++)
                char_array_4[i] = static_cast<unsigned char>(base64_chars.find(char_array_4[i]));

            char_array_3[0] = static_cast<unsigned char>(
                                  static_cast<unsigned int>(char_array_4[0] << 2) +
                                  static_cast<unsigned int>((char_array_4[1] & 0x30) >> 4)
                              );
            char_array_3[1] = static_cast<unsigned char>(
                                  static_cast<unsigned int>((char_array_4[1] & 0xf) << 4) +
                                  static_cast<unsigned int>((char_array_4[2] & 0x3c) >> 2)
                              );
            char_array_3[2] = static_cast<unsigned char>(
                                  static_cast<unsigned int>((char_array_4[2] & 0x3) << 6) +
                                  static_cast<unsigned int>(char_array_4[3])
                              );

            for(i = 0; (i < 3); i++)
                ret += static_cast<char>(char_array_3[i]);

            i = 0;
        }
    }

    if(i)
    {
        for(j = i; j < 4; j++)
            char_array_4[j] = 0;

        for(j = 0; j < 4; j++)
            char_array_4[j] = static_cast<unsigned char>(base64_chars.find(char_array_4[j]));

        char_array_3[0] = static_cast<unsigned char>(
                              static_cast<unsigned int>(char_array_4[0] << 2) +
                              static_cast<unsigned int>((char_array_4[1] & 0x30) >> 4)
                          );
        char_array_3[1] = static_cast<unsigned char>(
                              static_cast<unsigned int>((char_array_4[1] & 0xf) << 4) +
                              static_cast<unsigned int>((char_array_4[2] & 0x3c) >> 2)
                          );
        char_array_3[2] = static_cast<unsigned char>(
                              static_cast<unsigned int>((char_array_4[2] & 0x3) << 6) +
                              static_cast<unsigned int>(char_array_4[3])
                          );

        for(j = 0; (j < i - 1); j++)
            ret += static_cast<char>(char_array_3[j]);
    }

    //Remove zero from end
    if(ret.size() > 0)
    {
        if(ret[ret.size() - 1] == '\0')
            ret.resize(ret.size() - 1);
    }
}



size_t charsets_utils::utf8len(const char *s)
{
    size_t len = 0;

    while(*s)
        len += (*(s++) & 0xC0) != 0x80;

    return len;
}


int charsets_utils::UTF8Str_To_WStr(std::wstring &dest, const std::string &source)
{
#ifdef _WIN32
    dest.resize(source.lenght());
    int newSize = MultiByteToWideChar(CP_UTF8, 0, source.c_str(), source.length(), (wchar_t *)dest.c_str(), source.length());
    dest.resize(newSize);
    return newSize;
#else
    (void)dest;
    (void)source;
    return static_cast<int>(utf8len(source.c_str()));
#endif
}

int charsets_utils::WStr_To_UTF8Str(std::string &dest, const std::wstring &source)
{
#ifdef _WIN32
    int dest_len = source.lenght() * 2;
    dest.resize(dest_len);
    dest_len = WideCharToMultiByte(CP_UTF8, 0, source.c_str(), source.length(), (LPSTR)dest.c_str(), dest_len, NULL, NULL);
    dest.resize(dest_len);
    return dest_len;
#else
    (void)dest;
    (void)source;
    return static_cast<int>(source.size());
#endif
}
