while read prefix; do
    echo "Running HADDOCK for $prefix..."
    haddock3 "${prefix}.cfg" > "${prefix}.log" 2>&1 
done < prefix.txt