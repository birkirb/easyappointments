#!/usr/bin/env sh

createAppSettings() {
    cp $PROJECT_DIR/config-sample.php $PROJECT_DIR/config.php
    sed -i "s/DB_HOST       = ''/DB_HOST = '$DB_HOST'/g" $PROJECT_DIR/config.php
    sed -i "s/DB_USERNAME   = ''/DB_USERNAME = '$DB_USERNAME'/g" $PROJECT_DIR/config.php
    sed -i "s/DB_PASSWORD   = ''/DB_PASSWORD = '$DB_PASSWORD'/g" $PROJECT_DIR/config.php
    sed -i "s/DB_NAME       = ''/DB_NAME = '$DB_NAME'/g" $PROJECT_DIR/config.php
    if [ "$EMAIL_PROTOCOL" = "smtp" ]; then
        echo "Setting up email..."
        sed -i "s/\$config\['protocol'\] = 'mail'/\$config['protocol'] = 'smtp'/g" $PROJECT_DIR/application/config/email.php
        sed -i "s#// \$config\['smtp_host'\] = ''#\$config['smtp_host'] = '$SMTP_HOST'#g" $PROJECT_DIR/application/config/email.php
        sed -i "s#// \$config\['smtp_user'\] = ''#\$config['smtp_user'] = '$SMTP_USER'#g" $PROJECT_DIR/application/config/email.php
        sed -i "s#// \$config\['smtp_pass'\] = ''#\$config['smtp_pass'] = '$SMTP_PASS'#g" $PROJECT_DIR/application/config/email.php
        sed -i "s#// \$config\['smtp_crypto'\] = 'ssl'#\$config['smtp_crypto'] = '$SMTP_CRYPTO'#g" $PROJECT_DIR/application/config/email.php
        sed -i "s#// \$config\['smtp_port'\] = 25#\$config['smtp_port'] = $SMTP_PORT#g" $PROJECT_DIR/application/config/email.php
    fi
    if [ "$GOOGLE_SYNC_FEATURE" = "TRUE" ]; then
        echo "Setting up Google Calendar Sync..."
        sed -i "s/GOOGLE_SYNC_FEATURE   = FALSE/GOOGLE_SYNC_FEATURE   = TRUE/g" $PROJECT_DIR/config.php
        sed -i "s/GOOGLE_PRODUCT_NAME   = ''/GOOGLE_PRODUCT_NAME   = '$GOOGLE_PRODUCT_NAME'/g" $PROJECT_DIR/config.php
        sed -i "s/GOOGLE_CLIENT_ID      = ''/GOOGLE_CLIENT_ID      = '$GOOGLE_CLIENT_ID'/g" $PROJECT_DIR/config.php
        sed -i "s/GOOGLE_CLIENT_SECRET  = ''/GOOGLE_CLIENT_SECRET  = '$GOOGLE_CLIENT_SECRET'/g" $PROJECT_DIR/config.php
        sed -i "s/GOOGLE_API_KEY        = ''/GOOGLE_API_KEY        = '$GOOGLE_API_KEY'/g" $PROJECT_DIR/config.php
    fi
    sed -i "s/url-to-easyappointments-directory/$APP_URL/g" $PROJECT_DIR/config.php

    chown -R www-data $PROJECT_DIR
}


if [ "$1" = "run" ]; then

    echo "Preparing Easy!Appointments production configuration.."

    createAppSettings

    echo "Starting Easy!Appointments production server.."

    exec docker-php-entrypoint apache2-foreground

elif [ "$1" = "dev" ]; then

    echo "Preparing Easy!Appointments development configuration.."


    createAppSettings
    sed -i "s/DEBUG_MODE    = FALSE/DEBUG_MODE    = TRUE/g" $PROJECT_DIR/config.php

    echo "Starting Easy!Appointments production server.."

    exec docker-php-entrypoint apache2-foreground
fi

exec $@
