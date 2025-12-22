mkdir -p /var/www/app

set -e

RELEASES="APP_DIR/releases"
CURRENT="APP_DIR/current"

mkdir -p $RELEASES
mkdir -p $CURRENT

wget -O "$RELEASES/latest.zip" -d "$1"

rm -rf "$CURRENT"
mkdir -p "$CURRENT"
unzip "$RELEASES/latest.zip" -d "$CURRENT"

cd $CURRENT
npm install --production

pm2 restart all || pm2 start npm -- start

EOT

chmod +x /var/www/app/deploy.sh

EOF