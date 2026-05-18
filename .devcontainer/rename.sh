#!/bin/bash
if [ ! -f "./android_app/.app_configured" ]; then
    REPO_NAME=$(basename "$GITHUB_REPOSITORY")
    LOWER_REPO=$(echo "$REPO_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
    sed -i "s/rootProject.name = .*/rootProject.name = \"$REPO_NAME\"/" ./android_app/settings.gradle.kts
    sed -i -E "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$REPO_NAME<\/string>/" ./android_app/app/src/main/res/values/strings.xml
    sed -i "s/applicationId = \".*\"/applicationId = \"com.harley.$LOWER_REPO\"/" ./android_app/app/build.gradle.kts
    touch "./android_app/.app_configured"
    echo "Proyecto renombrado automáticamente a: $REPO_NAME"
fi
