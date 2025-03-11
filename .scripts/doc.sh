#!/bin/bash

# Змінні за замовчуванням
author_name="Ситник Є. С."
author_variant=15
author_group="ПЗПІ-23-2"
author_gender="m"

author_surname=$(echo "$author_name" | awk '{print $1}')


# Функція для створення нового документа
create_new_document() {
    subject_shorthand=$1
    doc_type=$2
    work_number=$3
    work_title=$4

    dir_path="$UNI/$subject_shorthand/$doc_type$work_number"

    mkdir -p "$dir_path"

    typ_path="${dir_path}/${doc_type}_№${work_number}_${author_surname}_${author_group}.typ"

    ln -sf "$UNI/templates/default.typ" "$dir_path/conf.typ"

    cat <<EOF > "$typ_path"
#import "conf.typ": conf
#show: conf.with(
    title: "$work_title",
    authors: ((name: "$author_name", variant: $author_variant, group: "$author_group", gender: "$author_gender"),),
    include_toc: false,
    doctype: "$doc_type",
    worknumber: $work_number,
    subject_shorthand: "$subject_shorthand",
)

= $work_title
== Мета роботи

== Хід роботи

== Висновки

== Контрольні запитання
EOF

    echo "Document created at: $typ_path"

    # Відкрити файл для редагування після створення
    cd "$dir_path"
    $EDITOR "$typ_path"
}

# Функція для редагування документа
edit_document() {
    subject_shorthand=$1
    doc_type=$2
    work_number=$3

    dir_path="$UNI/$subject_shorthand/$doc_type$work_number"
    typ_path="${dir_path}/${doc_type}_№${work_number}_${author_surname}_${author_group}.typ"

    if [[ -f "$typ_path" ]]; then
        cd "$dir_path"
        $EDITOR "$typ_path"
    else
        echo "Error: File does not exist: $typ_path"
    fi
}

# Функція для перегляду документа
view_document() {
    subject_shorthand=$1
    doc_type=$2
    work_number=$3


    dir_path="$UNI/$subject_shorthand/$doc_type$work_number"
    typ_path="${dir_path}/${doc_type}_№${work_number}_${author_surname}_${author_group}.typ"
    pdf_path="${dir_path}/${doc_type}_№${work_number}_${author_surname}_${author_group}.pdf"

    if [[ -f "$typ_path" ]]; then
        # Генерація PDF з Typst
        typst compile "$typ_path" "$pdf_path"
        if [[ -f "$pdf_path" ]]; then
            xdg-open "$pdf_path"
        else
            echo "Error: Failed to generate PDF: $pdf_path"
        fi
    else
        echo "Error: Typst file does not exist: $typ_path"
    fi
}

# Функція для видалення документа
delete_document() {
    subject_shorthand=$1
    doc_type=$2
    work_number=$3

    dir_path="$UNI/$subject_shorthand/$doc_type$work_number"
    typ_path="${dir_path}/${doc_type}_№${work_number}_${author_surname}_${author_group}.typ"

    if [[ -d "$dir_path" ]]; then
        rm -rf "$dir_path"
        echo "Directory deleted: $dir_path"
    else
        echo "Error: Directory does not exist: $dir_path"
    fi
}

# Головна логіка скрипта
command=$1

case $command in
    new)
        if [[ $# -lt 5 ]]; then
            echo "Usage: $0 new <subject> <doctype> <worknumber> <worktitle>"
            exit 1
        fi
        create_new_document "$2" "$3" "$4" "$5"
        ;;
    edit)
        if [[ $# -lt 4 ]]; then
            echo "Usage: $0 edit <subject> <doctype> <worknumber>"
            exit 1
        fi
        edit_document "$2" "$3" "$4"
        ;;
    view)
        if [[ $# -lt 4 ]]; then
            echo "Usage: $0 view <subject> <doctype> <worknumber>"
            exit 1
        fi
        view_document "$2" "$3" "$4"
        ;;
    delete)
        if [[ $# -lt 4 ]]; then
            echo "Usage: $0 delete <subject> <doctype> <worknumber>"
            exit 1
        fi
        delete_document "$2" "$3" "$4"
        ;;
    *)
        echo "Usage: $0
    new    <subject> <doctype> <worknumber> <worktitle>
    edit   <subject> <doctype> <worknumber>
    view   <subject> <doctype> <worknumber>
    delete <subject> <doctype> <worknumber>"
        ;;
esac
