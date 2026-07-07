# 🧊Pipeline Data E-commerce — Snowflake & dbt

Projet portfolio : pipeline de données de bout en bout pour un jeu de données e-commerce, depuis l'ingestion brute jusqu'à un dashboard analytique, en suivant une architecture medallion (RAW → STAGING → INTERMEDIATE → MARTS).

> Premier projet Snowflake réalisé dans le cadre de ma montée en compétences en Data Engineering, en complément de mon profil Data Analyst.

## 🔧 Stack technique

| Composant | Rôle |
|---|---|
| **Snowflake** | Data Warehouse cloud (compute, stockage, Time Travel, Zero-Copy Cloning) |
| **dbt Core** | Transformation, tests de qualité, documentation |
| **Snowpipe** | Ingestion automatisée de nouveaux fichiers |
| **Streams & Tasks** | Change Data Capture (CDC) et orchestration incrémentale |
| **Power BI** | Restitution et dashboard interactif |

##  Architecture

```
RAW (données brutes, VARCHAR, jamais modifiées)
  │
  ▼
STAGING (typage, nettoyage — vues dbt)
  │
  ▼
INTERMEDIATE (jointures, enrichissements — vues dbt)
  │
  ▼
MARTS (tables analytiques finales — tables dbt)
  │
  ▼
Power BI (dashboard)
```

### Détail des couches

- **RAW** : 6 tables sources (orders, customers, products, campaigns, returns, events) — le clickstream `events` inclut des données semi-structurées (VARIANT/JSON)
- **STAGING** : 6 modèles dbt (`stg_*`) — typage strict avec `TRY_TO_*` pour éviter les échecs de pipeline sur données malformées
- **INTERMEDIATE** : 2 modèles (`int_orders_enriched`, `int_orders_with_returns`) — jointures commandes/clients/produits/campagnes/retours
- **MARTS** : 2 tables de faits (`fct_orders`, `fct_customer_summary`) — prêtes pour la consommation BI

##  Qualité des données

22 tests dbt automatisés :
- `unique` / `not_null` sur toutes les clés primaires
- `accepted_values` sur les champs à valeurs contrôlées (statut commande, segment client)
- `relationships` pour l'intégrité référentielle entre marts

```bash
dbt test
# Done. PASS=21 WARN=1 ERROR=0 SKIP=0 NO-OP=0 TOTAL=22
```

## Fonctionnalités Snowflake avancées démontrées

- **Time Travel** : restauration de données après suppression accidentelle
- **Zero-Copy Cloning** : environnement de test sans duplication physique des données
- **Window functions** : `RANK()`, `SUM() OVER()`, `AVG() OVER()` pour analyses de cohortes et moyennes mobiles
- **Semi-structuré** : `PARSE_JSON`, `LATERAL FLATTEN` sur les données clickstream
- **Snowpipe** : chargement automatisé depuis un stage
- **Streams & Tasks** : détection automatique des nouvelles données (CDC) et déclenchement de traitement, avec journalisation

## Dashboard Power BI

Dashboard interactif avec :
- KPI : chiffre d'affaires net, clients actifs
- Répartition du CA par segment client et catégorie produit
- Évolution mensuelle des ventes
- Performance par canal marketing (Email, Facebook, Google Ads, Instagram)
- Segments de filtrage interactifs (statut, période)

*(captures d'écran à ajouter dans `/docs/screenshots`)*

## Structure du projet

```
ecommerce_analytics/
├── models/
│   ├── staging/
│   │   ├── _sources.yml
│   │   ├── _staging__models.yml
│   │   └── stg_*.sql
│   ├── intermediate/
│   │   ├── _intermediate__models.yml
│   │   └── int_*.sql
│   └── marts/
│       ├── _marts__models.yml
│       └── fct_*.sql
├── macros/
│   └── generate_schema_name.sql
├── dbt_project.yml
└── README.md
```

##  Reproduire le projet

```bash
# Environnement virtuel
python -m venv dbt-env
.\dbt-env\Scripts\Activate.ps1   # Windows
pip install dbt-snowflake

# Configuration (profiles.yml à créer dans ~/.dbt/, voir profiles.yml.example)
dbt debug

# Exécution du pipeline
dbt run
dbt test
dbt docs generate
dbt docs serve
```

##  Ce que ce projet m'a appris

Au-delà de la syntaxe SQL et dbt, ce projet a été l'occasion de déboguer des problèmes réels de pipeline de données :
- Détection et correction de doublons en amont (RAW) causés par des ré-exécutions de scripts d'ingestion
- Gestion des privilèges Snowflake spécifiques (`EXECUTE TASK`) hors du système `GRANT ALL PRIVILEGES` classique
- Compréhension du fan-out de jointures et de son impact silencieux sur les agrégations

---

**Auteur** : Daouda KA — Data Analyst / Data Engineer  Dakar, Sénégal