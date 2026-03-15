# fashion_gen

## Configuration in GCP :

1. create a repo in BigQuery
2. go on repo > <your repo> > configuration : to configure the connexion to your gitlab repo.
3. Find and complete the follawing page :
    ```bash
    Protocole du dépôt Git distant *
    HTTPS

    SSH
    URL du dépôt Git distant
    <your repo URL>
    Les URL des dépôts Git distants se terminent généralement par .git
    Nom de la branche par défaut
    <usually 'main' on GitLab>
    Secret 
    <your secret among the list>
    ```

    1. Choose the protocol : HTPPS or SSH
    2. write down the repo URL
    3. Write down the repo's default branch (usually main for GitLab)
    4. Choose the secret to access the repo (a GitLab Personal Access Token) :

        - in GCP Secret Manager (https://console.cloud.google.com/security/secret-manager?) create a secret
        - paste it the GitLab PAT value
        - grant to BigQuery's service account the following role to use this secret : "roles/secretmanager.secretAccessor"