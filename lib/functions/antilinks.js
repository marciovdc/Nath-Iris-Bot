"use strict";
const fs = require('fs');
const shell = require('shelljs');
const {
	mylang
} = require('../lang');
const {
	tools
} = require('./index');

/* Utilidades */
var Prox_Msg = 0;
var needs_ban = false;
var motive_ban = false;

/* Função para checar links +18 */
function linkURL(URLs, functions, chatId, type) {
	needs_ban = false;
	motive_ban = false;
	URLs.some(plink => {
		var Received_Value = false;
		if (functions.anylinks.includes(chatId) && tools('others').isUrl(plink) || functions.antilinks.includes(chatId) && tools('others').Is_Invite_Link(plink)) {
			Received_Value = true;
		} else if (functions.safelinks.includes(chatId)) {
			var Get_URLS = plink.match(/(http:\/\/)?(www\.)?\w+\.([a-zA-Z0-9]+)/gim) || [];
			Get_URLS = Get_URLS.filter(j => tools('others').isUrl(j));
			const is_BURL = (shell.exec(`bash lib/functions/config.sh badwords "${Get_URLS[0]}" "lib/config/Utilidades/hosts.txt"`, {
				silent: true
			})).stdout;
			if (is_BURL.includes('1')) {
				Received_Value = true;
			}
		}
		if (Received_Value == true) {
			needs_ban = true;
			motive_ban = `Link dentro de um/a ${type} ou nickname`;
			return true;
		}
	});
}

/* Sistemas de verificação */
exports.init = async (k, m) => {
	
	/* Transforma as variáveis da exports em constantes */
	const kill = k;
	const message = m;

	/* Desfaz as variáveis para impedir que ocorra ban sem motivo */
	needs_ban = false;
	motive_ban = false;

	/* Try Catch para evitar qualquer erro */
	try {

		/* JSON's | Utilidades */
		const functions = JSON.parse(fs.readFileSync('./lib/config/Gerais/functions.json'));
		const config = JSON.parse(fs.readFileSync('./lib/config/Settings/config.json'));
		const firewall = JSON.parse(fs.readFileSync('./lib/config/Settings/firewall.json'));
		
		/* Utilidades 1 */
		const isGroupMsg = message.isGroupMsg || false;
		const chatId = message.chatId || message.from || message.chat.contact.id || message.chat.groupMetadata.id || false;
		const type = message.type || false;
		const botNumber = (await kill.getHostNumber()) + '@c.us';
		const user = message.author || message.sender.id || false;
		const fromMe = message.fromMe || false;
		const isOwner = config.Owner.includes(user);
		const groupAdmins = (isGroupMsg ? await kill.getGroupAdmins(chatId) : [config.Owner[0], botNumber]) || [config.Owner[0], botNumber];
		const isGroupAdmins = (groupAdmins ? groupAdmins.includes(user) : false) || false;
		const isBotGroupAdmins = isGroupMsg ? groupAdmins.includes(botNumber) : false;

		/* Não filtra PV ou grupos que não ativaram, Íris precisa ser ADM para funcionar */
		if (!isGroupMsg || isGroupMsg && !functions.safelinks.includes(chatId) || isGroupMsg && !functions.antilinks.includes(chatId) || isGroupMsg && !functions.anylinks.includes(chatId) || type == 'ptt' || config.Check_Stickers == false && type == 'sticker' || !isBotGroupAdmins || isOwner || isGroupAdmins || fromMe) return true;

		/* Utilidades 2 [MSG] */
		const body = message.body || '';
		const content = message.content || '';
		const caption = message.caption || '';
		const comment = message.comment || '';
		const filename = message.filename || '';
		const footer = message.footer || '';
		const list = message.list || false;
		const name = message.chat.name || message.chat.formattedName || message.chat.contact.name || message.chat.contact.formattedName || '';
		const notifyName = message.sender.pushname || message.notifyName || false;
		const text = message.text || '';
		const stickerPack = (type == 'sticker' ? message.stickerPack || message.stickerPackName || message.mediaData.stickerPackName || '' : '') || '';
		const stickerAuthor = (type == 'sticker' ? message.stickerAuthor || message.stickerPackPublisher || message.mediaData.stickerPackPublisher || '' : '') || '';

		/* Utilidades secundarias */
		const list_title = (list ? list.title : '' || '');
		const list_description = (list ? list.description : '' || '');
		const list_buttonText = (list ? list.buttonText : '' || '');
		const list_footerText = (list ? list.footerText : '' || '');
		const VCFs_Name = message.vcardList ? message.vcardList.map(g => g.displayName || '') : '';
		const VCFs_Content = message.vcardList ? message.vcardList.map(g => g.vcard || '') : '';
		var Message_Texts = [];
		Message_Texts = Message_Texts.concat(text, footer, VCFs_Name, VCFs_Content, list_title, list_description, list_buttonText, list_footerText, caption, comment, filename);
		Message_Texts = type == 'video' || type == 'image' || type == 'location' ? Message_Texts : Message_Texts.concat(body, content);
		Message_Texts = config.Check_Stickers == true ? Message_Texts.concat(stickerAuthor, stickerPack) : Message_Texts;
		Message_Texts = config.Check_Nickname == true ? Message_Texts.concat(notifyName) : Message_Texts;
		const banned = user;
		var Can_Continue = true;

		/* Sistema para caso tenha botões híbridos */
		if (Object.keys(message).includes('hydratedButtons')) {
			if (message.hydratedButtons.length > 0) {
				const Special_Buttons_URL = message.hydratedButtons.filter(g => Object.keys(g).includes('urlButton'));
				const Special_Buttons_Call = message.hydratedButtons.filter(g => Object.keys(g).includes('callButton'));
				const Special_Buttons_Quick = message.hydratedButtons.filter(g => Object.keys(g).includes('quickReplyButton'));
				const Url_Button = Special_Buttons_URL.map(f => [f.urlButton.displayText, f.urlButton.url]);
				const Call_Button = Special_Buttons_Call.map(f => [f.callButton.displayText, f.callButton.phoneNumber]);
				const Quick_Button = Special_Buttons_Quick.map(f => [f.quickReplyButton.displayText, f.quickReplyButton.id]);
				Message_Texts = Message_Texts.concat(Url_Button, Call_Button, Quick_Button).flat();
			}
		}

		/* Caso tenha sessões em botões */
		if (list) {
			if (list.sections.length > 0) {
				const row_ids = list.sections[0].rows.filter(j => j.rowId).map(r => r.rowId);
				const row_title = list.sections[0].rows.filter(j => j.title).map(r => r.title);
				const row_desc = list.sections[0].rows.filter(j => j.description).map(r => r.description);
				const row_caption = list.sections[0].title || '';
				Message_Texts = Message_Texts.concat(row_title, row_ids, row_caption, row_desc);
			}
		}

		/* Corrige a Message_Texts */
		Message_Texts = ([...new Set(Message_Texts.filter(h => h !== '' && h !== null && h !== false))]).filter(g => tools('others').isUrl(g)).flat();

		/* Não verifica dono, ADMS e BOT */
		if (!isOwner && !isGroupAdmins && !fromMe) {

			/* Faz a verificação */
			linkURL(Message_Texts, functions, chatId, type);
			
		} else return true;

		/* Bane a pessoa caso grupo */
		if (needs_ban == true) {
			Can_Continue = false;
			console.log(tools('others').color('[ANTI-LINKS]', 'red'), tools('others').color(`Possível link recebido pelo → ${notifyName} - [${banned.replace('@c.us', '')}] no "${name || 'PV'}"...`, 'yellow'));
			if (isGroupMsg && isBotGroupAdmins) {
				await kill.removeParticipant(chatId, banned);
			}
			if (firewall.Block == true) {
				await kill.contactBlock(banned);
			}
		}

		/* Avisa o por que do banimento, uma vez por hora para casos de flood */
		if (needs_ban == true && Prox_Msg < Date.now() && isBotGroupAdmins) {
			Prox_Msg = Number(Date.now()) + 3600000;
			await kill.sendTextWithMentions(chatId, mylang(region).baninjusto(banned) + motive_ban + `.\n@${groupAdmins.join(' @').replace(/@c.us/gim, '')}`);
		}

		/* Diz se pode executar como comando ou mensagem */
		return Can_Continue;

		/* Caso der erro não afeta o funcionamento */
	} catch (error) {
		tools('others').reportConsole('ANTI-LINKS', error);
		return true;
	}

};