#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
ifs=$'\n\t'


# readonly input_file="$@"
readonly input_file="pico.css"

# Create a new partials folder
rm -rf "./css/partials"
mkdir "./css/partials"

# Create a copy of the pico file in the partials folder
cp "./css/pico.fluid.classless.slate.css" "./css/partials/pico.css"

# Navigate to the partials folder
cd "./css/partials"

output_file=""

line_counter=0
while ifs= read -r line; do
  line_counter=`expr ${line_counter} + 1`
  if [[ $line == "/*"* ]]; then
    # get the line number below the first comment line    
    line_number=`expr ${line_counter} + 1`

    # get the line of text from the file
    text1=`sed -n "${line_number}p" ${input_file}`

    # convert to lower case
    text2=`echo "${text1}" | tr '[:upper:]' '[:lower:]'`

    # convert spaces to hyphens
    text3=`echo "${text2}" | sed 's/ /-/g'`

    # remove non alpha-numeric characters (exlude hyphens)
    # alternative sed: 's/[^a-za-z0-9-]//g'
    text4=`echo "${text3}" | sed 's/[^[:alnum:]-]//g'`

    # convert double hyphens to single hyphens
    text5=`echo "${text4}" | sed 's/--/-/g'`

    # remove any hyphens at the front of the string
    text6=`echo "${text5}" | sed 's/^-//g'`

    # set the css file name for this section
    output_file="_${text6}.css"

    # create the file
    echo "$line" >> "$output_file"

  elif [[ $line == "*/" ]]; then
      echo "$line" >> "$output_file"
      # output_file=""
  elif [[ ! -z "$output_file" ]]; then
      echo "$line" >> "$output_file"
  fi
done < "$input_file"

# Clear up
rm "pico.css"
