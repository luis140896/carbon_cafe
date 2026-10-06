-- Normaliza los permisos almacenados en roles de notación ':' a notación '.'
-- para que backend, frontend y RoleGuard usen un solo formato.
-- Se reemplaza ':' por '.' dentro de cada elemento del array JSONB.

UPDATE roles
SET permissions = (
    SELECT jsonb_agg(to_jsonb(REPLACE(value, ':', '.')))
    FROM jsonb_array_elements_text(permissions) AS value
)
WHERE permissions IS NOT NULL;
