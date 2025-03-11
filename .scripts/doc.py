import sys
import subprocess
from pathlib import Path

import os
print(os.environ['HOME'])

# Configurations
UNI = "/path/to/university/works"
EDITOR = "nano"
TYPST = "typst"

subjects = {
    "БД": "Бази даних",
}

work_types = ["ЛБ", "ПЗ", "КУ"]

def rofi_menu(options, prompt):
    """Show a Rofi menu and return the selected option."""
    process = subprocess.run(
        ["rofi", "-dmenu", "-p", prompt], input="\n".join(options), text=True, stdout=subprocess.PIPE
    )
    return process.stdout.strip()

def get_works_list(subject):
    """Get a list of works for the given subject."""
    subject_path = Path(UNI) / subject
    return [
        str(file.relative_to(subject_path))[:-4]  # Remove .typ extension
        for file in subject_path.rglob("*.typ")
    ]

# Step 1: Select action
action = rofi_menu(["new", "edit", "view", "delete"], "Select action")
if not action:
    exit(1)

# Step 2: Select subject
subject = rofi_menu(subjects.keys(), "Select subject")
if not subject:
    exit(1)

if action != "new":
    # Show list of existing works
    works = get_works_list(subject)
    selected_work = rofi_menu(works, "Select work")
    if not selected_work:
        exit(1)
    file_path = Path(UNI) / subject / f"{selected_work}.typ"
    pdf_path = file_path.with_suffix(".pdf")
else:
    # Create a new work
    work_type = rofi_menu(work_types, "Select work type")
    if not work_type:
        exit(1)

    work_number = rofi_menu([], "Enter work number")
    if not work_number:
        exit(1)

    work_title = rofi_menu([], "Enter work title")
    if not work_title:
        exit(1)

    author_surname = "Ситник"
    author_group = "ПЗПІ-23-2"
    file_name = f"{work_type}_№{work_number}_{author_surname}_{author_group}"
    file_path = Path(UNI) / subject / f"{work_type}{work_number}" / f"{file_name}.typ"
    pdf_path = file_path.with_suffix(".pdf")

    file_path.parent.mkdir(parents=True, exist_ok=True)
    with open(file_path, "w") as f:
        f.write(f"""#import \"conf.typ\": conf
#show: conf.with(
    title: \"{work_title}\",
    authors: ((name: \"Ситник Є. С.\", variant: 15, group: \"{author_group}\", gender: \"m\"),),
    mentor: (name: \"Mentor Name\", gender: \"m\", degree: \"PhD\"),
    include_toc: false,
    doctype: \"{work_type}\",
    worknumber: {work_number},
    subject: \"{subjects[subject]}\",
)

= {work_title}
== Мета роботи

== Хід роботи

== Висновки

== Контрольні запитання
""")
    print(f"File created at {file_path}")
    subprocess.run([EDITOR, str(file_path)])
    exit(0)

# Perform action
if action == "edit":
    if file_path.exists():
        subprocess.run([EDITOR, str(file_path)])
    else:
        print(f"File not found: {file_path}", file=sys.stderr)
elif action == "view":
    if file_path.exists():
        subprocess.run([TYPST, "compile", str(file_path), str(pdf_path)])
        subprocess.run(["xdg-open", str(pdf_path)])
    else:
        print(f"File not found: {file_path}", file=sys.stderr)
elif action == "delete":
    if file_path.exists():
        file_path.unlink(missing_ok=True)
        pdf_path.unlink(missing_ok=True)
        print(f"Deleted: {file_path} and {pdf_path}")
    else:
        print(f"File not found: {file_path}", file=sys.stderr)
else:
    print(f"Unknown action: {action}", file=sys.stderr)
    exit(1)
