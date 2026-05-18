#!/bin/bash

if [ ! -f "./android_app/.app_configured" ]; then
    
    # 1. Nombres base
    REPO_NAME=$(basename "$GITHUB_REPOSITORY")
    LOWER_REPO=$(echo "$REPO_NAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
    
    OLD_PKG="com.ncorti.kotlin.template"
    NEW_PKG="com.harley.$LOWER_REPO"
    
    # 2. Renombrar el proyecto general y el nombre de la app
    sed -i "s/rootProject.name = .*/rootProject.name = \"$REPO_NAME\"/" ./android_app/settings.gradle.kts
    sed -i -E "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$REPO_NAME<\/string>/" ./android_app/app/src/main/res/values/strings.xml
    
    # 3. Buscar y reemplazar el paquete en TODOS los archivos del proyecto (imports, namespace, applicationId, xml, etc)
    find ./android_app -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.kts" -o -name "*.pro" \) -exec sed -i "s/$OLD_PKG/$NEW_PKG/g" {} +
    
    # 4. Mover físicamente las carpetas a la nueva estructura com/harley/...
    find ./android_app -type d -name "template" | grep "com/ncorti/kotlin/template" | while read template_dir; do
        # Extraer la ruta base antes del paquete viejo
        base_dir=$(echo "$template_dir" | sed "s|/com/ncorti/kotlin/template||")
        
        # Crear la nueva ruta de carpetas
        mkdir -p "$base_dir/com/harley/$LOWER_REPO"
        
        # Mover los archivos de la vieja a la nueva
        mv "$template_dir"/* "$base_dir/com/harley/$LOWER_REPO"/ 2>/dev/null
        
        # Eliminar el rastro del desarrollador viejo
        rm -rf "$base_dir/com/ncorti"
    done
    
    # 5. Marcar como configurado
    touch "./android_app/.app_configured"
    echo "Refactorización absoluta completada a: $NEW_PKG"
fi
