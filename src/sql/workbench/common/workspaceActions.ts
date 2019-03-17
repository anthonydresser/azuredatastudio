import { Action } from 'vs/base/common/actions';
import { IWindowsService } from 'vs/platform/windows/common/windows';
import { URI } from 'vs/base/common/uri';

export class ShowFileInFolderAction extends Action {

	constructor(private path: string, label: string, private windowsService: IWindowsService) {
		super('showItemInFolder.action.id', label);
	}

	run(): Promise<void> {
		return this.windowsService.showItemInFolder(URI.parse(this.path));
	}
}

export class OpenFileInFolderAction extends Action {

	constructor(private path: string, label: string, private windowsService: IWindowsService) {
		super('showItemInFolder.action.id', label);
	}

	run() {
		return this.windowsService.openExternal(this.path);
	}
}
