#!/usr/bin/env bash
gst-launch-1.0 -v \
      videomixer name=mix sink_0::alpha=0.7 sink_1::alpha=0.6 ! videoconvert !  videoscale ! autovideosink \
      filesrc location=cat.png ! decodebin ! videoconvert ! videoscale ! imagefreeze !\
      video/x-raw,format=RGB,width=257,height=257,framerate=10/1 ! tee name=t \
      t. ! queue ! mix. \
      t. ! queue ! tensor_converter !\
      tensor_transform mode=arithmetic option=typecast:float32,add:0.0,div:255.0 !\
      tensor_filter framework=tensorflow-lite model=tflite_img_segment_model/deeplabv3_257_mv_gpu.tflite !\
      tensor_decoder mode=image_segment option1=tflite-deeplab ! mix.
