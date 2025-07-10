#!/bin/bash

MENU_FILE="/etc/xdg/menus/lxqt-applications.menu"
BACKUP_FILE="/etc/xdg/menus/lxqt-applications.menu.bak"
CATEGORY_NAME="foss4g-workshop"

# XML block to add
read -r -d '' MENU_BLOCK << EOF
  <Menu>
    <Name>$CATEGORY_NAME</Name>
    <Directory>${CATEGORY_NAME}.directory</Directory>
    <Include>
      <Category>$CATEGORY_NAME</Category>
    </Include>
  </Menu>
EOF

echo "🔍 Checking if '$CATEGORY_NAME' already exists in LXQt menu..."

# Check if the block is already present
if grep -q "<Name>$CATEGORY_NAME</Name>" "$MENU_FILE"; then
    echo "✅ '$CATEGORY_NAME' already exists in the menu. No changes made."
    exit 0
fi

echo "📦 Backing up menu file to $BACKUP_FILE..."
cp "$MENU_FILE" "$BACKUP_FILE"

echo "📝 Appending new menu block..."

# Insert before last </Menu>
tmpfile=$(mktemp)
awk -v block="$MENU_BLOCK" '
  {
    print
    if (!done && /<\/Menu>/) {
      print block
      done=1
    }
  }
' "$MENU_FILE" > "$tmpfile"


# Replace original
mv "$tmpfile" "$MENU_FILE"

chmod 644 /etc/xdg/menus/lxqt-applications.menu
