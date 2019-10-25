#!/bin/bash
set -e
java_conf_content=/opt/java/conf
java_conf_git=git@gitee.com:yijiedai-yunwei/Yjd_Java_Conf.git
java_code_git=git@gitee.com:yijiedai-java/p-parent.git
java_code=/opt/java/p-parent
java_code_bak=/opt/java/p-parent-bak
branch1=master
branch2=task_20191025

# 更新配置
update_conf(){
    if [ -d $java_conf_content ];then
        cd $java_conf_content
        git pull origin master:master  || {  $dingding |sh -s 请注意：配置文件更新失败，程序退出！; exit 1; }
    else
        mkdir -p $java_conf_content
        git clone $java_conf_git $java_conf_content || {  $dingding |sh -s 请注意：配置文件更新失败，程序退出！; exit 1; }
    fi
}

# 更新代码
update_code(){
    echo "=================开始拉取p-parent代码======================"
    if [ -d $java_code ]; then
        cd $java_code
        git fetch --all || { echo "代码更新失败，退出程序"; $dingding |sh -s 请注意：代码更新失败，程序退出！; exit 1; } #&& $dingding |sh -s 请悉知：代码更新完成！
    else
        git clone $java_code_git  $java_code
        cd $java_code
        git fetch --all || { echo "代码更新失败，退出程序"; $dingding |sh -s 请注意：代码更新失败，程序退出！; exit 1; } #&& $dingding |sh -s 请悉知：代码更新完成！ 
    fi
}

# 编译代码
maven_code(){
    local select=$1
    echo "=================开始进行编译====================="
    rm -rf $java_code_bak
    cp -a $java_code  $java_code_bak
    cd $java_code_bak
    if [ $select == "1" ];then
        git checkout $branch1
        rm -rf  $java_code_bak/config/test.properties
        cp -rf $java_conf_content/uat/test.properties  $java_code_bak/config/test.properties
    elif [ $select == "3" ];then
        git checkout $branch2
        rm -rf  $java_code_bak/config/test.properties
        cp -rf $java_conf_content/java-branch/test.properties  $java_code_bak/config/test.properties
    else
        $dingding | sh -s 编译时出错，切换分支失败！
    fi 
    sed -i "s:/code/IdeaProjects/p-parent:$java_code_bak:" $java_code_bak/pom.xml
    /opt/apache-maven-3.6.1/bin/mvn clean install -Dmaven.test.skip=true -P test  || { echo "编译失败，退出程序"; $dingding |sh -s 请注意：maven编译失败,程序退出！; exit 1; }  
}

# 复制jar包
copy_code(){
    local select=$1
    cd $java_code_bak
    for i in `cat $java_conf_content/uat/applyname.txt`
    do
        if [ $select == "1" ];then
            cp ./$i /www/p-java-common-uat/
        elif [ $select == "3" ];then
            cp ./$i /www/p-java-common-test/
        else
            $dingding | sh -s 复制jar包失败！
        fi
        
    done || {  $dingding |sh -s 请注意：jar包复制失败，程序退出！; exit 1; }
    $dingding |sh -s   请悉知：maven编译成功！
}

# 主函数
main_java(){
    local choose=$1
    if [ $choose == "1" ];then
        $dingding |sh -s 请悉知：开始更新master代码...
        update_conf;
        update_code;
        maven_code $choose
        copy_code $choose
    elif [ $choose == "2" ];then
	update_conf
        bash $java_conf_content/uat/updateapply.sh
    elif [ $choose == "3" ];then
        $dingding |sh -s 请悉知：开始更新分支代码...
        update_conf;
        update_code;
        maven_code $choose
        copy_code $choose
    elif [ $choose == "4" ];then
	update_conf;
        bash $java_conf_content/java-branch/updateapply.sh
    else
        $dingding |sh -s 执行错误!
    fi
}

main_java $1 2>&1 | tee ./logs/deploy.log
