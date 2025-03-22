#!/bin/bash
# Initialize a new Git repository and commit the current directory contents

set -e

echo "🚀 Initializing Git repository..."
git init

echo "📝 Creating initial .gitignore..."
cat > .gitignore << EOF
# Environment variables
.env

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Docker volumes
docker-volumes/

# OS specific
.DS_Store
Thumbs.db
EOF

echo "➕ Adding files to Git..."
git add .

echo "✅ Creating initial commit..."
git commit -m "Initial commit for MCP Server Docker setup"

echo "💡 Repository initialized. Next steps:"
echo "1. Add a remote with: git remote add origin <your-repository-url>"
echo "2. Push to remote with: git push -u origin main"
echo ""
echo "Or use the push-repo.sh script after setting your repository URL."
