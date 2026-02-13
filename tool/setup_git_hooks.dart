/* 
  Sets up a git pre-commit hook in .git/hooks/pre-commit that runs
  dart_pre_commit
 */
import 'dart:io' show File, Platform, Process, stdout, stderr, exitCode;

Future<void> main() async {
  final preCommitHook = File('.git/hooks/pre-commit');
  await preCommitHook.parent.create();
  await preCommitHook.writeAsString('''
#!/bin/sh
exec dart run dart_pre_commit # specify custom options here
''');

  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['a+x', preCommitHook.path]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
  }
}
