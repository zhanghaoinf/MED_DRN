function BB_CNN_Extract(stCvid, edCvid)
% Region CNN Feature Extractor
%
addpath('../')
paramInit
softset_rc
stVid   = str2num(stCvid);
edVid   = str2num(edCvid);
% Resize Keyframe to fix size
HIGHT = 360;
WIDTH = 480;
rcRatio = 0.25;
areaRatio = (0.3)^2;
picformat = '.jpg';
imAreaBound = HIGHT * WIDTH * areaRatio;
default_boxNum = 20;
threshold_box_overlap = 0.5;
CEvent_ID = ['Event_BG'];
BOUND_BOX = [ dataRoot,'BOUND_BOX/', CEvent_ID, '/'];
BB_IMAGE =  [ dataRoot,'BB_IMAGE/', CEvent_ID, '/'];
% Out Folder
Bound_box_Event_folder = [ BOUND_BOX];
bb_Event_Folder = [ BB_IMAGE ];
dirmake(Bound_box_Event_folder);
dirmake(bb_Event_Folder); 
% image vid list
VID_LIST_PATH = [ tvMed, 'STRUCTURE/',CEvent_ID ,'.txt' ];
vid_list      = textread(VID_LIST_PATH, '%s', 'delimiter', '\n');
vid_num	      = length(vid_list);
% image folder
edVid = min([edVid, vid_num]);
for vid_cnt = stVid: edVid
	vid = strtrim(vid_list{vid_cnt});
	Event_Image_folder = [ tvMed, 'VIDEO_ORIGINAL_KF/', CEvent_ID, '/'];
	Bound_box_Vid_folder = [ Bound_box_Event_folder, vid, '/' ];
	dirmake(Bound_box_Vid_folder);
	bb_Vid_folder = [bb_Event_Folder, vid, '/'];
	dirmake(bb_Vid_folder);
	vid_folder = [ Event_Image_folder, vid,'/' ];
	keyframe_list = dir([vid_folder,'*', picformat]);
	keyframe_num  = length(keyframe_list);
	for frame_cnt = 1: keyframe_num
		fprintf('|Processing %s: %d of %d VID: %d of %d Frame|\n',CEvent_ID,vid_cnt, vid_num, frame_cnt, keyframe_num);
		keyframe_id = keyframe_list(frame_cnt).name;
		keyframe_id = strtrim(keyframe_id);
		save_id = strrep(keyframe_id,picformat,'');
		Bound_box_frame_path = [ Bound_box_Vid_folder, save_id, '.mat' ];
		if (exist(Bound_box_frame_path))
			continue;
		end
		im_path  = [ vid_folder, keyframe_id ];
		im = imread(im_path);
		im = imresize(im, [HIGHT, WIDTH], 'bilinear');
		[ boxes, blobIndIm,blobBoxes, hierarchy ] = Image2HierarchicalGrouping(im,SIGMA,K,MINSIZE,colorType,simFunctionHandles);
		boxes = BoxRemoveDuplicates(boxes);
		boxes = remove_overlap(boxes,threshold_box_overlap);
		temp_box = size(boxes);
		boxesNum = temp_box(1);
		delete_boxIndex = [];
		max_boxNum = min([boxesNum, default_boxNum]);
		boxes = boxes(1:max_boxNum,:);
		cnt_idx = 1;
		for cnt = 1:max_boxNum
			temp_idx = boxes(cnt,:);
			temp_r   = (temp_idx(3) - temp_idx(1)) ;
			temp_c   = (temp_idx(4) - temp_idx(2)) ;
			if(temp_r < temp_c * rcRatio || temp_c /rcRatio < temp_r || temp_r * temp_c < imAreaBound)
				delete_boxIndex = [ delete_boxIndex,cnt];
			else
				bbImage = im(temp_idx(1):temp_idx(3),temp_idx(2):temp_idx(4),:);
				bbSavePath = [ bb_Vid_folder, save_id, '_',num2str(cnt_idx),'.jpg'];
				imwrite(bbImage, bbSavePath);
				cnt_idx = cnt_idx + 1;
			end
		end
		boxes(delete_boxIndex,:) = [];
		temp_box = size(boxes);
		boxesNum = temp_box(1);
		save(Bound_box_frame_path,'boxes');
	
	end
end
	%save('im.mat','im')
end
