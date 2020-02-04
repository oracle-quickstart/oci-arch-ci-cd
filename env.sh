#!/usr/bin/env bash
#Enter Your Tenancy OCID
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaafsvnqi3w2viowquzjfute7e26akiz7gtzawk7mtdvw7muen6gmzq"
#Enter Your Compartment OCID
export TF_VAR_compartment_ocid="ocid1.compartment.oc1..aaaaaaaakhijtkdrfjmypzxdoe7re7gotvcdneinfvulz43hifdikrxnkl4q"
#Enter Your User OCID
export TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaa2psptap4nqcijadklxq33wksac7isetwknuenfwacpf5ci7liyea"
#Enter Your Fingerprint
export TF_VAR_fingerprint="56:70:ce:28:cd:cb:3e:58:df:19:6e:68:95:99:36:31"
#Enter Your Region (Example: us-ashburn-1)
export TF_VAR_region="us-ashburn-1"
#Enter the Image OCID
export TF_VAR_image_ocid="ocid1.image.oc1.iad.aaaaaaaawufnve5jxze4xf7orejupw5iq3pms6cuadzjc7klojix6vmk42va"
#Enter Shape for Instance (Example: VM.Standard2.1)
export TF_VAR_instance_shape="VM.Standard2.1"
#Enter Path to Your Private API Key
export TF_VAR_private_key_path="/Users/kartikhegde/Desktop/key/oci_api_key.pem"
#Enter Path to Your Public SSH Key
export TF_VAR_ssh_public_key=$(cat /Users/kartikhegde/Desktop/key/Instance.pub)
#Enter Path to Your Private SSH Key
export TF_VAR_ssh_authorized_private_key=$(cat /Users/kartikhegde/Desktop/key/Instance)
