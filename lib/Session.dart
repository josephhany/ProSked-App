import 'package:http/http.dart' as http;

class Session {

    Map<String, String> cookies = {};

    String updateCookie(http.Response response) {
        String allSetCookie = response.headers['set-cookie'];

        if (allSetCookie != null) {
            var setCookies = allSetCookie.split(',');

            for (var setCookie in setCookies) {
                var cookies = setCookie.split(';');

                for (var cookie in cookies) {
                    _setCookie(cookie);
                }
            }

            //headers['cookie'] = _generateCookieHeader();
            return _generateCookieHeader();
        }
    }

    void _setCookie(String rawCookie) {
        if (rawCookie.length > 0) {
            var keyValue = rawCookie.split('=');
            if (keyValue.length == 2) {
                var key = keyValue[0].trim();
                var value = keyValue[1];

                // ignore keys that aren't cookies
                if (key == 'path' || key == 'expires')
                    return;

                cookies[key] = value;
            }
        }
    }

    String _generateCookieHeader() {
        String cookie = "";

        for (var key in cookies.keys) {
            if (cookie.length > 0)
                cookie += ";";
            cookie += key + "=" + cookies[key];
        }

        return cookie;
    }
}