package internal

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os/exec"
	"strings"
)

type PrefetchResult struct {
	Hash string `json:"hash"`
}

func PrefetchHash(url string) (string, error) {
	cmd := exec.Command("nix", "store", "prefetch-file", "--json", url)
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out
	if err := cmd.Run(); err != nil {
		return "", fmt.Errorf("prefetch failed: %v: %s", err, out.String())
	}
	var res PrefetchResult
	if err := json.Unmarshal(out.Bytes(), &res); err != nil {
		return "", err
	}
	if res.Hash == "" {
		return "", fmt.Errorf("empty hash for %s", url)
	}
	return res.Hash, nil
}

func NixBuildOracle() (string, error) {
	cmd := exec.Command("nix", "build", ".#oracle")
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out
	err := cmd.Run()
	return out.String(), err
}

func NixBuildSummarize() (string, error) {
	cmd := exec.Command("nix", "build", ".#summarize")
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out
	err := cmd.Run()
	return out.String(), err
}

func ExtractGotHash(log string) string {
	for _, line := range strings.Split(log, "\n") {
		if idx := strings.Index(line, "got: sha256-"); idx != -1 {
			return strings.TrimSpace(line[idx+5:])
		}
	}
	return ""
}
