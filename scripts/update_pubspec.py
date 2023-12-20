import requests
import yaml


def fetch_latest_version(package_name):
    url = f"https://pub.dev/api/packages/{package_name}"
    response = requests.get(url)
    response.raise_for_status()
    package_data = response.json()
    latest_version = package_data['latest']['version']
    return latest_version


def update_dependencies(pubspec_path, packages_latest, specified_versions):
    with open(pubspec_path, 'r') as file:
        pubspec = yaml.safe_load(file)

    # Update to latest versions
    for package in packages_latest:
        if 'dependencies' in pubspec and package in pubspec['dependencies']:
            latest_version = fetch_latest_version(package)
            pubspec['dependencies'][package] = f'^{latest_version}'

    # Update to specified versions
    for package, version in specified_versions.items():
        if 'dependencies' in pubspec and package in pubspec['dependencies']:
            pubspec['dependencies'][package] = version

    with open(pubspec_path, 'w') as file:
        yaml.dump(pubspec, file, indent=2)


packages_latest = [
    # Firebase
    'firebase_analytics',
    'firebase_app_check',
    'firebase_core',
    'firebase_crashlytics',
    'firebase_in_app_messaging',
    'firebase_messaging',
    'firebase_performance',
    'firebase_remote_config',

    # Lingua
    'lingua_ad',
    'lingua_apps',
    'lingua_calculator',
    'lingua_core',
    'lingua_countries',
    'lingua_finance',
    'lingua_finance_dividend',
    'lingua_finance_forex',
    'lingua_finance_instrument',
    'lingua_finance_stock',
    'lingua_help',
    'lingua_languages',
    'lingua_number',
    'lingua_onboarding',
    'lingua_purchases',
    'lingua_settings',
    'lingua_units',

    # T
    'tbloc',
    't_cache',
    'tenhance',
    'tlogger',
    't_helpers',
    'tenhtloggerance',
    'tmodel',
    'tstore',
    'tsub',
    'subx',

    # MateX
    'matex_financial',
    'matex_core',
    'matex_data',
]

specified_versions = {
    'another_flushbar': '^1.12.30',
    'app_tracking_transparency': '^2.0.4',
    'connectivity_plus': '^5.0.2',
    'decimal': '^2.3.3',
    'shimmer': '^3.0.0',
    'device_info_plus': '^9.1.1',
    'package_info_plus': '^5.0.1',
    'rate_my_app': '^2.0.0',
    'share_plus': '^7.2.1',
    'diacritic': '^0.1.4',
    'devicelocale': '^0.7.0',
    'easy_localization': '^3.0.3',
    'flutter_spinkit': '^5.2.0',
    'async': '^2.11.0',
    'http': '^1.1.0',
    'rxdart': '^0.27.7',
    'collection': '^1.18.0',
    'font_awesome_flutter': '^10.6.0',
    'google_fonts': '^6.1.0',
    'fuzzy': '^0.5.1',
    'google_mobile_ads': '^3.1.0',
    'url_launcher': '^6.2.1',
    'uuid': '^4.2.1',
    'visibility_detector': '^0.4.0+2',
    'go_router': '^12.1.1',
    'video_player': '^2.8.1',
    'flutter_native_splash': '^2.3.6',
}

# This is the path to the pubspec.yaml file
pubspec_path = './pubspec.yaml'

# Call the function to update the dependencies
update_dependencies(pubspec_path, packages_latest, specified_versions)
