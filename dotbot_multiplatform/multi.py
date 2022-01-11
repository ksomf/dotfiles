import os
import subprocess
import platform

import dotbot
import dotbot.util


class MultiPlatformShell(dotbot.Plugin):
    '''
    Run arbitrary shell commands, with additional multi platform and git support.
    '''

    _directive = 'mp_shell'
    _has_shown_override_message = False

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Shell cannot handle directive %s' %
                directive)
        return self._process_commands(data)

    def _process_commands(self, data):
        success = True
        defaults = self._context.defaults().get('mp_shell', {})
        options = self._get_option_overrides()
        system = platform.system().lower()
        for item in data:
            stdin = defaults.get('stdin', False)
            stdout = defaults.get('stdout', False)
            stderr = defaults.get('stderr', False)
            quiet = defaults.get('quiet', False)
            test = defaults.get('if', None)
            github = defaults.get('github', None)
            target_working_directory = self._context.base_directory()
            if isinstance(item, dict):
                cmd = item.get('command',None)
                cmd = item.get(system,cmd)

                msg = item.get('description', None)
                stdin = item.get('stdin', stdin)
                stdout = item.get('stdout', stdout)
                stderr = item.get('stderr', stderr)
                quiet = item.get('quiet', quiet)
                test = item.get('if', test)
                github = item.get('github', github)
            elif isinstance(item, list):
                cmd = item[0]
                msg = item[1] if len(item) > 1 else None
            else:
                cmd = item
                msg = None
            if msg is None:
                self._log.lowinfo(cmd)
            elif quiet:
                self._log.lowinfo('%s' % msg)
            else:
                self._log.lowinfo('%s [%s]' % (msg, cmd))
            stdout = options.get('stdout', stdout)
            stderr = options.get('stderr', stderr)
            if cmd is None:
                self._log.lowinfo('Skipping on platform %s' % cmd)
                continue
            if test is not None and not self._test_success(test):
                self._log.lowinfo('Skipping %s' % cmd)
                continue
            if github is not None:
                target_working_directory = os.path.expanduser('~/.local/share/') + os.path.basename(github).replace('.git','')
                test_cmd = 'test -d %s' % target_working_directory
                self._log.lowinfo('\tgithub: %s' % github)
                self._log.lowinfo('\tclone target: %s' % target_working_directory)
                self._log.lowinfo('\t%s' % test_cmd)
                target_working_directory_missing = dotbot.util.shell_command(test_cmd)
                if target_working_directory_missing:
                    git_cmd = 'git clone --depth=1 %s %s' % (github,target_working_directory)
                    self._log.lowinfo('\t%s' % git_cmd)
                    ret = dotbot.util.shell_command(
                        git_cmd,
                        enable_stdin=stdin,
                        enable_stdout=stdout,
                        enable_stderr=stderr
                    )
                    if ret != 0:
                        success = False
                        self._log.warning('Git Command [%s] failed' % git_cmd)
                        continue
                else:
                    git_cmd = 'git status -uno | grep "behind" && git pull || echo "up to date"'
                    self._log.lowinfo('\t%s' % git_cmd)
                    ret = dotbot.util.shell_command(
                        git_cmd,
                        cwd=target_working_directory,
                        enable_stdin=stdin,
                        enable_stdout=stdout,
                        enable_stderr=stderr
                    )
                    if ret != 0:
                        success = False
                        self._log.warning('Git Command [%s] failed' % git_cmd)
                        continue
            #self._log.info('%s [%s] -> %s' % (msg,cmd,target_working_directory))
            ret = dotbot.util.shell_command(
                cmd,
                cwd=target_working_directory,
                enable_stdin=stdin,
                enable_stdout=stdout,
                enable_stderr=stderr
            )
            if ret != 0:
                success = False
                self._log.warning('Command [%s] failed' % cmd)
        if success:
            self._log.info('All commands have been executed')
        else:
            self._log.error('Some commands were not successfully executed')
        return success

    def _get_option_overrides(self):
        ret = {}
        options = self._context.options()
        if options.verbose > 1:
            ret['stderr'] = True
            ret['stdout'] = True
            if not self._has_shown_override_message:
                self._log.debug("Shell: Found cli option to force show stderr and stdout.")
                self._has_shown_override_message = True
        return ret

    def _test_success(self, command):
        ret = dotbot.util.shell_command(command, cwd=self._context.base_directory())
        if ret != 0:
            self._log.debug('Test \'%s\' returned false' % command)
        return ret == 0
