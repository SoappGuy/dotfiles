#!/bin/bash

# Список предметів та типів робіт
declare -A subjects=(
    [math]="Mathematics"
    [phys]="Physics"
    [cs]="Computer Science"
    [БД]="Бази даних"
)
declare -a work_types=("ЛБ" "ПЗ" "КУ")

# Функція для відображення меню Rofi
menu_cmd() {
    echo -e "$1" | rofi -dmenu -p "$2"
}

# Функція для отримання списку робіт з предмету
get_works_list() {
    subject=$1
    find "$UNI/$subject" -type f -name "*.typ" -printf "%f\n" | sed 's/\.typ$//' | sort
}

# Крок 1: Вибір дії
action=$(menu_cmd "new\nedit\nview\ndelete" "Select action")
if [[ -z "$action" ]]; then
    exit 1
fi

# Крок 2: Вибір предмету
subject=$(menu_cmd "$(printf "%s\n" "${!subjects[@]}")" "Select subject")
if [[ -z "$subject" ]]; then
    exit 1
fi

# Для всіх операцій, окрім створення нового файлу, показуємо список робіт
if [[ "$action" != "new" ]]; then
    selected_work="$(menu_cmd "$(get_works_list "$subject")" "Select work")"
    if [[ -z "$selected_work" ]]; then
        exit 1
    fi
    file_path="$UNI/$subject/$selected_work.typ"
    pdf_path="$UNI/$subject/$selected_work.pdf"
else
    # Для створення нового файлу запитуємо деталі
    work_type=$(menu_cmd "$(printf "%s\n" "${work_types[@]}")" "Select work type")
    if [[ -z "$work_type" ]]; then
        exit 1
    fi

    work_number=$(menu_cmd "" "Enter work number")
    if [[ -z "$work_number" ]]; then
        exit 1
    fi

    work_title=$(menu_cmd "" "Enter work title")
    if [[ -z "$work_title" ]]; then
        exit 1
    fi

    author_surname="Ситник"
    author_group="ПЗПІ-23-2"
    file_name="${work_type}_№${work_number}_${author_surname}_${author_group}"
    file_path="$UNI/$subject/$work_type$work_number/$file_name.typ"
    pdf_path="$UNI/$subject/$work_type$work_number/$file_name.pdf"

    mkdir -p "$(dirname "$file_path")"
    cat <<EOF > "$file_path"
#import "conf.typ": conf
#show: conf.with(
    title: "$work_title",
    authors: ((name: "Ситник Є. С.", variant: 15, group: "$author_group", gender: "m"),),
    mentor: (name: "Mentor Name", gender: "m", degree: "PhD"),
    include_toc: false,
    doctype: "$work_type",
    worknumber: $work_number,
    subject: "${subjects[$subject]}",
)

= $work_title
== Мета роботи

== Хід роботи

== Висновки

== Контрольні запитання
EOF
    echo "File created at $file_path"
    $EDITOR "$file_path"
    exit 0
fi

# Виконання дій
case $action in
    edit)
        if [[ -f "$file_path" ]]; then
            $EDITOR "$file_path"
        else
            echo "File not found: $file_path" >&2
        fi
        ;;
    view)
        if [[ -f "$file_path" ]]; then
            $TYPST compile "$file_path" "$pdf_path"
            xdg-open "$pdf_path"
        else
            echo "File not found: $file_path" >&2
        fi
        ;;
    delete)
        if [[ -f "$file_path" ]]; then
            rm -f "$file_path"
            rm -f "$pdf_path"
            echo "Deleted: $file_path and $pdf_path"
        else
            echo "File not found: $file_path" >&2
        fi
        ;;
    *)
        echo "Unknown action: $action" >&2
        exit 1
        ;;
esac
