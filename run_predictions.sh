#!/bin/bash

RAWDIR="/mnt/eifiler03/geomatique/01_projects/CIME/sky_segmentation/DATA/RAW/"
CONVERT=False
PREDICT=True

for i in {1..1}; do
    if [ ${CONVERT} == "True" ]; then
        for img in "${RAWDIR}"${i}/*.JPG; do
            f=${img##*/};
            echo "Converting image: "${f};
            sudo convert "${img}" \
            -resize "960x720" \
            "My_dataset_${i}"/${f%.*}.png;
        done
        echo "Conversions done successfully!";
    fi
    if [ ${PREDICT} == "True" ]; then
        for img in My_dataset_${i}/*.png; do
            f=${img##*/};
            echo "Making prediction on image: "${f};
            python3 predict.py \
            --image "${img}" \
            --model "FC-DenseNet56" \
            --checkpoint_path ./checkpoints/latest_model_FC-DenseNet56_CamVid.ckpt;
            sudo mv ${f%.*}"_pred.png" My_dataset_${i}/;
        done
        echo "Predictions done successfully!";
    fi
done