function ff_movie(a,filename)


aviobj = avifile(filename,'fps',4);
func = @(x,y) rect(x/2).*rect(y/2);

for n=a
    fprintf('fresnel number %g',n);
    out = fdiffract(func,n);
    out = out/max(max(out));
    out = logim(out,3);
    s = size(out);
    if (s(1)>256)
        out = imresize(out,[256 256]);
    end
    rgb = cat(3,out,out,out);
    aviobj = addframe(aviobj,im2frame(rgb));
end

aviobj = close(aviobj);
