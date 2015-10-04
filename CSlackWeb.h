
#include <stdio.h>
#include <string>
#include <map>
#include <cerrno>
#include <json/json.h>       // libjson0-dev
#include <curl/curl.h>       // libcurl4-gnutls-dev

#include "CLogging.h"

class CSlackWeb
{
public:
  CSlackWeb(CLogging *log, std::string _ApiUrl, std::string _token);
  int init();
  std::string get_ws_url();  
  std::string get_username_from_id(std::string user_id);
  std::string get_channel_from_id(std::string channel_id);
  std::string get_id_from_channel(std::string channel_name);
  static std::string extract_value(string json_in, string param);

private:
  int slack_rtm_start(std::string &payload);
  static size_t s_curl_write(char *data, size_t size, size_t nmemb, void *p);

  int extract_users(std::string json_in);
  int extract_channels(std::string json_in);
  void dbg(std::string msg);

  CLogging *_log;
  char _errorBuffer[CURL_ERROR_SIZE];
  
  std::string _ApiUrl;
  std::string _token;
  std::string _ws_url;
  std::map<std::string, std::string> _users;
  std::map<std::string, std::string> _channels;
};

