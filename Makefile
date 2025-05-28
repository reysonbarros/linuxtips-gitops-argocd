create-all: create-cluster create-namespace install-argocd

create-cluster:
	kind create cluster --config k8s/cluster.yaml

create-namespace:
	kubectl apply -f k8s/argocd-ns.yaml

install-argocd:
	kubectl apply -n argocd -f k8s/argocd-crd.yaml

apply-application-giropops-senhas:
	kubectl apply -f applications/giropops-senhas.yaml

apply-application-apps-of-apps:
	kubectl apply -f applications/app-of-apps.yaml	

delete-all:	
	kind delete clusters argocd
