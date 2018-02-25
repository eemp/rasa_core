#!/bin/bash

set -e

function print_help {
    echo "Available options:"
    echo " help                                                     - Print this help"
    echo " download {mitie, spacy en, spacy de}                     - Download packages for mitie or spacy (english or german)"
    echo " run                                                      - Run an arbitrary command inside the container"
    echo " start-nlu-server commands (rasa cmd line arguments)      - Start RasaNLU server"
    echo " start-nlu-server -h                                      - Print RasaNLU help"
    echo " train-rasa-core commands (rasa core cmd line arguments)  - Train RasaCore"
    echo " run-rasa-core commands (rasa core cmd line arguments)    - Run RasaCore"
}

function download_package {
    case $1 in
        mitie)
            echo "Downloading mitie model..."
            python -m rasa_nlu.download -p mitie
            ;;
        spacy)
            case $2 in 
                en|de)
                    echo "Downloading spacy.$2 model..."
                    python -m spacy download "$2"
                    echo "Done."
                    ;;
                *) 
                    echo "Error. Rasa_nlu supports only english and german models for the time being"
                    print_help
                    exit 1
                    ;;
            esac
            ;;
        *) 
            echo "Error: invalid package specified."
            echo 
            print_help
            ;;
    esac
}

case ${1} in
    download)
        download_package ${@:2}
        ;;
    run)
        exec "${@:2}"
        ;;
    start-nlu-server)
        exec python -m rasa_nlu.server "${@:2}"
        ;;
    train-rasa-core)
        exec python -m rasa_core.train "${@:2}"
        ;;
    run-rasa-core)
        exec python -m rasa_core.run "${@:2}"
        ;;
    *)
        print_help
        ;;
esac

