#! /bin/bash

set -x
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$SCRIPT_DIR" >/dev/null

#Parse command line arguments
downloadHighPolySuv=true
if [[ $1 == "--no-full-poly-car" ]]; then
    downloadHighPolySuv=false
fi

#get sub modules
git submodule update --init --recursive

#give user perms to access USB port - this is not needed if not using PX4 HIL
#TODO: figure out how to do below in travis
if [ "$(uname)" == "Darwin" ]; then
    if [[ ! -z "${whoami}" ]]; then #this happens when running in travis
        sudo dseditgroup -o edit -a `whoami` -t user dialout
    fi

    #below takes way too long
    # brew install llvm@3.9
    brew install --force-bottle homebrew/versions/llvm39
else
    if [[ ! -z "${whoami}" ]]; then #this happens when running in travis
        sudo /usr/sbin/useradd -G dialout $USER
        sudo usermod -a -G dialout $USER
    fi

    #install clang and build tools
    sudo apt-get install -y build-essential
    sudo apt-get install cmake
fi

# Download high-polycount SUV model
if [ ! -d "Unreal/Plugins/AirSim/Content/VehicleAdv" ]; then
    mkdir -p "Unreal/Plugins/AirSim/Content/VehicleAdv"
fi
if [ ! -d "Unreal/Plugins/AirSim/Content/VehicleAdv/SUV/v1.1.7" ]; then
    if $downloadHighPolySuv; then
        echo "*********************************************************************************************"
        echo "Downloading high-poly car assets.... The download is ~37MB and can take some time."
        echo "To install without this assets, re-run setup.sh with the argument --no-full-poly-car"
        echo "*********************************************************************************************"
        
        if [ -d "suv_download_tmp" ]; then
            rm -rf "suv_download_tmp"
        fi
        mkdir -p "suv_download_tmp"
        cd suv_download_tmp
        wget  https://github.com/Microsoft/AirSim/releases/download/v1.1.7/car_assets.zip
        unzip car_assets.zip -d ../Unreal/Plugins/AirSim/Content/VehicleAdv
        cd ..
        rm -rf "suv_download_tmp" 
    else
        echo "Not downloading high-poly car asset. The default unreal vehicle will be used."
    fi
fi

popd >/dev/null

set +x
echo ""
echo "************************************"
echo "AirSim setup completed successfully!"
echo "************************************"
