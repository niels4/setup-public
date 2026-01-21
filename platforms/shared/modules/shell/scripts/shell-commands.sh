rsync -r --exclude='/.git' --filter="dir-merge,- .gitignore" src-dir/ dst-dir

while sleep 1; do ~/.local/share/nvim/mason/bin/codelldb --port 13000; done

rsync -r -l --exclude='/.git' --exclude="node_modules/" --delete --filter="dir-merge,- .gitignore" src-dir/ dst-dir

rsync -r --exclude='/.git' --exclude="node_modules/" --delete --filter="dir-merge,- .gitignore" $SETUP_DIR arch:setup
