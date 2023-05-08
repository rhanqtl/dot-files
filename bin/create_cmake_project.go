package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path"
	"strings"
	"text/template"
)

const (
	templateDir       = "cmake-project-template"
	cmakeListsFileName = "CMakeLists.txt"
)

var (
	projectName = flag.String("name", "", "project name")
	cppStandard = flag.String("std", "20", "C++ standard")
	parentDir   = flag.String("dir", "", "parent directory of the project")

	exeRoot string
)

func printUsage() {
	fmt.Fprintln(os.Stderr, `usage: create-cmake-project -name { project-name } [ -std { standard } ]`)
}

func init() {
	flag.Parse()
	if *projectName == "" {
		printUsage()
		os.Exit(1)
	}
	if *cppStandard == "" {
		*cppStandard = "20"
	}
	if *parentDir == "" {
		*parentDir, _ = os.Getwd()
	}

	exeRoot = os.Getenv("EXE_ROOT")
}

type config struct {
	ProjectName string
	CppStandard string
}

var validCppStandards = map[string]struct{}{
	"11": {}, "17": {},
	"14": {}, "20": {},
}

func (c *config) sanitize() {
	// TODO: make projectName canonical
	if _, ok := validCppStandards[c.CppStandard]; !ok {
		panic(fmt.Sprintf("invalid C++ standard: %v", c.CppStandard))
	}
}

func main() {
	var projectDir = path.Join(*parentDir, *projectName)
	if err := makeCopy(projectDir); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	conf := config{
		ProjectName: *projectName,
		CppStandard: *cppStandard,
	}
	conf.sanitize()

	var topLevelCMake = path.Join(projectDir, cmakeListsFileName)
	tpl := template.Must(template.New(cmakeListsFileName).ParseFiles(topLevelCMake))
	outF, err := os.OpenFile(topLevelCMake, os.O_WRONLY, 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to open %s for writing: %v", cmakeListsFileName, err)
		os.Exit(1)
	}
	defer outF.Close()
	if err := tpl.Execute(outF, conf); err != nil {
		panic(err)
	}
}

func makeCopy(projectDir string) error {
	if !exists(*parentDir) {
		if err := exec.Command("mkdir", "-p", *parentDir); err != nil {
			return fmt.Errorf("failed to create containing directory: %v", err)
		}
	}
	if exists(projectDir) {
		return fmt.Errorf("directory %q already exists", projectDir)
	}
	from := path.Join(exeRoot, templateDir)
	args := []string{"-r", from, projectDir}
	fmt.Printf("executing command %q\n", strings.Join(args, " "))
	if err := exec.Command("cp", args...).Run(); err != nil {
		return fmt.Errorf("failed to make a copy from template: %v", err)
	}
	return nil
}

func exists(path string) bool {
	if _, err := os.Stat(path); err != nil {
		return false
	}
	return true
}
