#!/bin/bash
echo ""
echo "欢迎使用压缩包生成脚本 :-)"
echo "作者：直心 ^_^ 日期：2020.12.24"
echo ""
echo "选择压缩模式"
echo "tar 仅使用tar打包，无压缩"
echo "xz 使用tar打包并使用xz压缩"
echo "zip 使用zip打包并压缩"
echo "q 退出"
read -p "请输入你的选择: " compress
echo ""

while [[ $compress != "tar" && $compress != "xz" && $compress != "zip" && $compress != "q" ]]
do
    echo "输入错误"
    echo "选择压缩模式"
    echo "tar 仅使用tar打包，无压缩"
    echo "xz 使用tar打包并使用xz进行多线程压缩"
    echo "zip 使用zip打包并压缩"
    echo "q 退出"
    read -p "请输入你的选择: " compress
    echo ""
done

if [ $compress == "q" ];then
    exit
fi

echo "选择使用模式"
echo "a 压缩指定目录下的所有文件和文件夹到单独的压缩包"
echo "b 压缩指定文件或目录为一个压缩包"
read -p "请输入你的选择: " mode
echo ""

while [[ $mode != "a" && $mode != "b" ]]
do
    echo "输入错误"
    echo "选择使用模式"
    echo "a 压缩指定目录下的所有文件和文件夹到单独的压缩包"
    echo "b 压缩指定文件或目录为一个压缩包"
    read -p "请输入你的选择: " mode
    echo ""
done

if [ $mode == "a" ];then
    echo "请输入将要压缩的目录的绝对路径"
    read files
    echo "请输入将要用于保存压缩包的目录的绝对路径"
    read save
    echo ""
    files=${files#\'}
    files=${files%\'}
    save=${save#\'}
    save=${save%\'}
    while [ ! -d "$files" ]
    do
        echo "输入的目录不存在或者输入的不是一个目录！请重新输入将要压缩的目录的绝对路径："
        read files
        files=${files#\'}
        files=${files%\'}
        echo ""
    done
    while [ ! -d "$save" ]
    do
        read -p "将要用于保存压缩包的目录不存在！是否要创建这个目录? [y/n]: " mk
        if [ $mk == "y" ];then
            read -p "目录确认无误？ [y/n]: " mk
            if [ $mk == "y" ];then
                mkdir -p "$save"
                if [ $? -eq 0 ];then
                    echo "创建成功"
                else 
                    echo "创建失败"
                    mk="n"
                fi
            fi
        fi
        if [ $mk != "y" ];then
            echo "请输入将要用于保存压缩包的目录的绝对路径"
            read save
            save=${save#\'}
            save=${save%\'}
        fi
        echo ""
    done
    FILES=`ls "$files"`
    for i in $FILES
    do
    ## 循环遍历静默压缩
        if [ $i != "folds2compress" ];then
            if [ $compress == "tar" ];then
                echo "使用tar直接打包: $i.tar"
                tar -cPf "$save/$i.tar" "$files/$i"
                echo "当前文件结束"
            fi
            if [ $compress == "xz" ];then
                echo "使用多线程和默认压缩级别: $i.tar.xz"
                tar -cPf - "$files/$i" | xz -T0 -v -c > "$save/$i.tar.xz"
                echo "当前文件结束"
            fi
            if [ $compress == "zip" ];then
                echo "使用 zip 进行打包和压缩: $i.zip"
                zip -rq "$save/$i.zip" "$files/$i"
                echo "当前文件结束"
            fi
        fi
    done
else
    echo "请输入将要压缩的文件或目录的绝对路径"
    read files
    echo "请输入将要用于保存压缩包的目录的绝对路径"
    read save
    echo ""
    files=${files#\'}
    files=${files%\'}
    save=${save#\'}
    save=${save%\'}
    while [ ! -e "$files" ]
    do
        echo "输入的路径不存在！请重新输入将要压缩的文件或目录的绝对路径："
        read files
        files=${files#\'}
        files=${files%\'}
        echo ""
    done
    while [ ! -d "$save" ]
    do
        read -p "将要用于保存压缩包的目录不存在！是否要创建这个目录? [y/n]: " mk
        if [ $mk == "y" ];then
            read -p "目录确认无误？ [y/n]: " mk
            if [ $mk == "y" ];then
                mkdir -p "$save"
                if [ $? -eq 0 ];then
                    echo "创建成功"
                else 
                    echo "创建失败"
                    mk="n"
                fi
            fi
        fi
        if [ $mk != "y" ];then
            echo "请重新输入将要用于保存压缩包的目录的绝对路径"
            read save
            save=${save#\'}
            save=${save%\'}
        fi
        echo ""
    done
    name=${files##*/}
    if [ $compress == "tar" ];then
        echo "使用tar直接打包: $i.tar"
        tar -cPf "$save/$name.tar" "$files"
    fi
    if [ $compress == "xz" ];then
        echo "使用多线程和默认压缩级别: $name.tar.xz"
        tar -cPf - "$files" | xz -T0 -v -c > "$save/$name.tar.xz"
    fi
    if [ $compress == "zip" ];then
        echo "使用 zip 进行打包和压缩: $i.zip"
        zip -rq "$save/$name.zip" "$files"
    fi
fi
echo "所有压缩工作结束"
echo ""
