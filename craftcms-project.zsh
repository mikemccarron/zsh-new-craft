# Setup new CraftCMS project

function new_craft(){
	echo -e "What is this projects name? \c"
	read PROJECT_NAME
	mkdir $PROJECT_NAME && cd $PROJECT_NAME

	mkdir -p tmp
	curl "http://buildwithcraft.com/latest.zip?accept_license=yes" -L -o tmp/craft.zip
	unzip tmp/craft.zip
	pushd craft
	chmod 774 app config storage
	popd
	mv public/htaccess public/.htaccess
	rm public/web.config
	rm -rf tmp

	echo "&lt;?php
	if (file_exists(__DIR__ . '/' . \$_SERVER['REQUEST_URI'])) {
		return false;
	} else {
		include_once 'index.php';
	}" > public/router.php

	# mysql -uroot --password= -e "create database if not exists craft_local_$PROJECT_NAME";

	echo "&lt;?php
	return array(
		'server' => 'localhost',
		'user' => 'root',
		'password' => '',
		'database' => 'craft_local_$PROJECT_NAME',
		'tablePrefix' => 'craft'
	);" > craft/config/db.php

	pushd public
	# php -S localhost:4000 router.php
}