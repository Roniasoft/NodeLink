import os
import re
import requests

# -----------------------------------------
# Configuration
# -----------------------------------------
ROOT_DIR = r"E:/family/dadash/work/ROMINA/work_1/NodeLink/Docs"
TIMEOUT = 5
LINK_PATTERN = re.compile(r'\[[^\]]*\]\(([^)]+)\)')

# -----------------------------------------
# Helpers
# -----------------------------------------
def find_markdown_files(root):
    md_files = []
    for base, _, files in os.walk(root):
        for f in files:
            if f.lower().endswith(".md"):
                md_files.append(os.path.join(base, f))
    return md_files


def check_external_link(url):
    try:
        r = requests.head(url, allow_redirects=True, timeout=TIMEOUT)
        return r.status_code < 400
    except Exception:
        return False


def check_local_link(src_file, link):
    # Resolve relative local file path
    resolved = os.path.abspath(os.path.join(os.path.dirname(src_file), link))

    # Remove anchors (#section)
    resolved = resolved.split('#')[0]

    return os.path.exists(resolved)


# -----------------------------------------
# Main logic
# -----------------------------------------
broken_links = []

print("Scanning...")

for md_file in find_markdown_files(ROOT_DIR):
    with open(md_file, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    links = LINK_PATTERN.findall(text)

    for link in links:
        if link.startswith("http://") or link.startswith("https://"):
            ok = check_external_link(link)
            status = "OK" if ok else "BROKEN"
        else:
            ok = check_local_link(md_file, link)
            status = "OK" if ok else "MISSING FILE"

        if status != "OK":
            broken_links.append((md_file, link, status))
            print(f"{status:13} | {md_file} → {link}")


print("\nDone.\n")

print("Summary:")
for src, dst, st in broken_links:
    print(f"{st:13} | {src} → {dst}")
