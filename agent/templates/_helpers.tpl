{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pushServiceAccountSecret" }}
{{- printf "{\"type\": \"service_account\", \"project_id\": \"%s\", \"private_key_id\": \"%s\", \"private_key\": \"%s\", \"client_email\": \"%s\", \"client_id\": \"%s\", \"auth_url\": \"%s\", \"token_uri\": \"%s\", \"auth_provider_x509_cert_url\": \"%s\", \"client_x509_cert_url\": \"%s\"}" .Values.secrets.pushServiceAccountKey.projectId .Values.secrets.pushServiceAccountKey.privateKeyId (.Values.secrets.pushServiceAccountKey.privateKey | replace "\n" "\\n") .Values.secrets.pushServiceAccountKey.clientEmail .Values.secrets.pushServiceAccountKey.clientId .Values.secrets.pushServiceAccountKey.authUri .Values.secrets.pushServiceAccountKey.tokenUri .Values.secrets.pushServiceAccountKey.authProviderX509CertUrl .Values.secrets.pushServiceAccountKey.clientX509CertUrl | b64enc }}
{{- end }}

{{- define "pullServiceAccountSecret" }}
{{- printf "{\"auths\": {\"gcr.io": {\"auth\": \"%s\"}}}" (printf "_json_key:%s" (printf "{\"type\": \"service_account\", \"project_id\": \"%s\", \"private_key_id\": \"%s\", \"private_key\": \"%s\", \"client_email\": \"%s\", \"client_id\": \"%s\", \"auth_url\": \"%s\", \"token_uri\": \"%s\", \"auth_provider_x509_cert_url\": \"%s\", \"client_x509_cert_url\": \"%s\"}" .Values.secrets.pushServiceAccountKey.projectId .Values.secrets.pushServiceAccountKey.privateKeyId (.Values.secrets.pushServiceAccountKey.privateKey | replace "\n" "\\n") .Values.secrets.pushServiceAccountKey.clientEmail .Values.secrets.pushServiceAccountKey.clientId .Values.secrets.pushServiceAccountKey.authUri .Values.secrets.pushServiceAccountKey.tokenUri .Values.secrets.pushServiceAccountKey.authProviderX509CertUrl .Values.secrets.pushServiceAccountKey.clientX509CertUrl | b64enc) | b64enc }}
{{- end }}
