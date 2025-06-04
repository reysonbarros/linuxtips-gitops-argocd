#### Link do repo de exemplo

https://github.com/bernardolsp/descomplicando-gitops-no-kubernetes-argocd

fork do projeto: https://github.com/reysonbarros/linuxtips-gitops-argocd

Nota: Realizar um fork desse repo para realizar os laboratórios práticos

#### Instalação do ArgoCD
```
make
```

#### Obter a secret
```
kubectl get secrets -n argocd

kubectl get secret argocd-initial-admin-secret -n argocd -o yaml

echo -n "password" | base64 -d
```

#### Criar um port-forward para o servico argocd-server
```
k get svc argocd-server -n argocd

k port-forward svc/argocd-server -n argocd 8080:443
```

#### Acessar via browser
url: http://localhost:8080

User:admin

Password: ver item # Obter a secret

#### Sync Window

Através desse recurso é possível escolher o dia na semana e o momento que sua aplicação pode sincronizar. 

Sempre é bom mitigar antes os riscos de impactos aos clientes.

#### Ferramenta para criação de diagramas de aplicações

https://excalidraw.com


#### O que são os applications?
São manifestos yaml que indicam o source(repo da sua aplicação), o destination(onde sua aplicação vai ser feito o deploy) e a forma do deploy(automático ou manual).

Nota: O ArgoCD por default observa se houve alguma alteração no repositório(fonte da verdade) a cada 3 minutos, e em caso positivo, atualiza o cluster.

*************************************************************************************************

#### Configurando um projeto com application via UI do ArgoCD

Nota: Antes dessa configuração no ArgoCD é preciso gerar um Acess Token no github

<b>Github</b>

Settings -> Developer Settings -> Persnoal Access Tokens -> Tokens(classic) -> Generate new token(classic) -> Generate token

Note:linuxtips-gitops-argocd

Expiration: 7 dias

Select Scopes: selecionar somente repo


<b>ArgoCD</b>

Settings -> Repositories -> + Connect Repo -> Connect

Connection method: VIA HTTPS

Type: git

Project: default

Repository url: https://github.com/reysonbarros/linuxtips-gitops-argocd.git

Username: token

Password: access token gerado no Github

Select Skip server verification

Nota: Não é obrigatório que os arquivos application do ArgoCD estejam no mesmo repo da aplicação.

#### Criar o application no ArgoCD
```
kubectl apply -f applications/giropops-senhas.yaml
```

#### Criar o application de app-of-apps ArgoCD
```
kubectl apply -f applications/app-of-apps.yaml
```

#### Instalando o ngrok para expor o serviço local do argocd na Internet
```
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok
```

#### Configurando o token do ngrok
```
ngrok config add-authtoken <your_token>
```

#### Expondo a url local do argocd pelo ngrok
```
ngrok http https://localhost:8080
```

#### Acessar a url gerada pelo ngrok
```
https://efc9-2804-d4b-9435-5900-f3c1-210b-6581-e116.ngrok-free.app
```

#### Configurando um Webhooks no Github
Project -> Settings -> Webhooks -> Add webhook
Payload url:  https://efc9-2804-d4b-9435-5900-f3c1-210b-6581-e116.ngrok-free.app/api/webhook -> endpoint do webhook do argocd
Content type: application/json
SSL Verification: Disable
Which events would you like to trigger this webhook? Send me everything.
Para ambiente produtivo habilitar somente Push e Repositories
Habilitar Active


Nota: Webhooks permite um serviço externo ser notificado quando certos eventos ocorrem.

#### Adiconando uma Sync Window do ArgoCD
Settings -> Projects -> Select project(default or specific) -> Open tab Sync Window -> Add Sync Window

Kind: allow(permitir) ou deny(revogar)
Schedule: representa o momento em que a Sync Window será ativada
Time Zone: representa o horário baseado no time zone Pais/Cidade
Duration: representa a duração da Sync Window
Applications: representa as aplicações atribuídas para a Sync Window
Namespaces: representa os namespaces atribuídos para a Sync Window
Clusters: representa os clusters atribuídos para a Sync Window




### Troubleshooting

Source: ArgoCD

Problem: Failed to load target state: failed to generate manifest for source 1 of 1: rpc error: code = Unknown desc = unable to resolve 'feat/day2' to a commit SHA

Solution: Executar o push na branch específica para o remote server, deletar o application e aplicá-lo novamente

Exemplo: 
```
git add .
git commit -m "comment"
git push origin feat/day2
kubectl delete -f application/giropops-senhas.yaml
kubectl apply -f application/giropops-senhas.yaml
```



