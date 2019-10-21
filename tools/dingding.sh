# 钉钉通知
dingding(){
local dingding=$1
local url='https://oapi.dingtalk.com/robot/send?access_token=4631afa4fc15cbd63423cd60890c36face98485e30a4751cedc1ab1548c5817c'
curl ''$url'' \
   -H 'Content-Type: application/json' \
   -d '{"msgtype": "text", 
        "text": {
             "content": "'$dingding'"
        }
      }'
}
dingding $1
