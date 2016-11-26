/* Joins war_graves records to cef_enlistees records */

/* There are a few (3) war graves that match more than one enlistee. Only one is not
 * a duplicate, but two separate people with the same name and regimental number.
 * Their name is LIONEL DEGRE. We simply ignore those records.
 *
 * This script runs in about 60 seconds on my machine, and matches 23 572 graves.
 */

/* War graves that match more than one person (3 results with the original data sets) */
WITH non_unique_matches AS (
	SELECT wg.id FROM cef_enlistees cef

	JOIN cef_enlistees_regimental_numbers rn
	ON rn.cef_enlistees_id=cef.id

	JOIN war_graves wg
	ON
		wg.given_name=cef.given_name
		AND wg.surname=cef.surname
		AND wg.servicenumberexport=rn.regimental_number

	WHERE
		wg.given_name IS NOT NULL
		AND wg.surname IS NOT NULL
		
	GROUP BY wg.id
	HAVING COUNT(*) > 1
),

/* Key-value of war grave IDs and their corresponding enlistee ID */
cef_matches AS (
	SELECT wg2.id AS wg_id, cef2.id AS cef_id FROM cef_enlistees cef2

	JOIN cef_enlistees_regimental_numbers rn2
	ON rn2.cef_enlistees_id=cef2.id

	JOIN war_graves wg2
	ON
		wg2.given_name=cef2.given_name
		AND wg2.surname=cef2.surname
		AND wg2.servicenumberexport=rn2.regimental_number
		AND wg2.id NOT IN (
			SELECT id FROM non_unique_matches
		)
)

UPDATE war_graves wg SET cef_enlistees_id=(
	SELECT cef_id FROM cef_matches WHERE wg_id=wg.id LIMIT 1
)
WHERE id IN (
	SELECT wg_id FROM cef_matches
)