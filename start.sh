#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
set -e
export cur_dir=`pwd`
export git=https://raw.githubusercontent.com/Joehenu/Yjddevops/master
export dingding='curl -s '$git'/tools/dingding.sh'

# 系统部署
java_deploy(){
    local choose=$1
    if [ $choose == "1" ];then
        curl -fsSL  $git/items/yjd-java/module/deploy.sh | sh -s 1 
    elif [ $choose == "2" ];then
        curl -fsSL  $git/items/yjd-java/module/deploy.sh | sh -s 2
    elif [ $choose == "3" ];then
        curl -fsSL  $git/items/yjd-java/module/deploy.sh | sh -s 3
    elif [ $choose == "4" ];then
        curl -fsSL  $git/items/yjd-java/module/deploy.sh | sh -s 4
    else
        echo "系统错误"
    fi
}

# 主函数
main_menu(){
    clear
    local choose=$1
    echo "清选择需要的操作:"
    echo 
    echo -e " 1) 仅maven编译 \n 2) UAT环境部署  \n 3) 退出系统 "
    if [ "$choose" ];then
        echo "选择："$choose
    else
        echo 
        read -p "请选择:" choose 
    fi
    if [ "$choose" == "1" ];then
        java_deploy $choose
    elif [ "$choose" == "2" ];then
        java_deploy $choose
    elif [ "$choose" == "3" ];then
        java_deploy $choose
    elif [ "$choose" == "4" ];then
        java_deploy $choose
    else
        echo "退出系统"
    fi
}

########从这里开始运行程序######
rm -rf ./logs && mkdir logs
main_menu $1 2>&1 | tee ./logs/start.log
