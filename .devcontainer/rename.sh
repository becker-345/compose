#!/bin/bash

if [ ! -f "./android_app/.app_configured" ]; then
    
    REPO_NAME=$(basename "$GITHUB_REPOSITORY")
    LOWER_REPO=$(echo "$REPO_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
    
    OLD_PKG="com.ncorti.kotlin.template"
    NEW_PKG="com.harley.$LOWER_REPO"
    
    sed -i "s/rootProject.name = .*/rootProject.name = \"$REPO_NAME\"/" ./android_app/settings.gradle.kts
    sed -i -E "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$REPO_NAME<\/string>/" ./android_app/app/src/main/res/values/strings.xml
    
    # ¡AQUÍ ESTÁ LA MAGIA ARREGLADA! Añadimos -o -name "*.properties"
    find ./android_app -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.kts" -o -name "*.pro" -o -name "*.properties" \) -exec sed -i "s/$OLD_PKG/$NEW_PKG/g" {} +
    
    find ./android_app -type d -name "template" | grep "com/ncorti/kotlin/template" | while read template_dir; do
        base_dir=$(echo "$template_dir" | sed "s|/com/ncorti/kotlin/template||")
        mkdir -p "$base_dir/com/harley/$LOWER_REPO"
        mv "$template_dir"/* "$base_dir/com/harley/$LOWER_REPO"/ 2>/dev/null
        rm -rf "$base_dir/com/ncorti"
    done
    
    touch "./android_app/.app_configured"
    echo "Refactorización absoluta completada a: $NEW_PKG"
fi
