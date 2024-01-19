import yaml
import sys

# This is the path to the pubspec.yaml file
pubspec_path = './pubspec.yaml'


def check_dependency_overrides(file_path):
    with open(file_path, 'r') as file:
        pubspec = yaml.safe_load(file)

    # Check if 'dependency_overrides' is in the pubspec
    if 'dependency_overrides' in pubspec:
        overrides = pubspec['dependency_overrides']

        # Check if there are any overrides other than 'font_awesome_flutter'
        for package in overrides:
            if package != 'font_awesome_flutter':
                return False

    return True


result = check_dependency_overrides(pubspec_path)

if not result:
    sys.exit("Error: Dependency overrides found other than 'font_awesome_flutter'.")

print("Check passed.")
