CREATE OR REPLACE FUNCTION api.prepare()
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    BEGIN
      EXECUTE admin.analyze_db();

      --If the concept.prepare() function exists then execute it.
      IF(EXISTS(SELECT 1
                  FROM pg_proc as f
                  JOIN pg_namespace as s
                    ON s.oid = f.pronamespace
                 WHERE f.proname = 'prepare'
                   AND s.nspname = 'concept' ))
      THEN
        PERFORM concept.prepare();
      END IF;

      --Return true to indicate that the preparation succeeded.
      RETURN TRUE;

    EXCEPTION WHEN others THEN

      --Return false to indicate that the preparation failed.
      RETURN FALSE;
    END;
  END;
$function$
