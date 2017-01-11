From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM 2.0 RM flushcontext returning bad address
Date: Wed, 11 Jan 2017 14:43:50 -0500
Message-ID: <o561te$39p$1@blaine.gmane.org>
References: <o53ei5$sc5$1@blaine.gmane.org>
	<20170110200803.GB5102@obsidianresearch.com>
	<o53ncb$e8q$1@blaine.gmane.org>
	<20170110224225.GA5451@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170110224225.GA5451-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/10/2017 5:42 PM, Jason Gunthorpe wrote:
> On Tue, Jan 10, 2017 at 05:31:45PM -0500, Ken Goldman wrote:
>> On 1/10/2017 3:08 PM, Jason Gunthorpe wrote:
>>>> 4 - Is a write() error desirable?  I think the application would prefer
>>>> a TPM formatted response like TPM_RC_VALUE.
>
> .. and we have to define what all the possible errnos mean. Defining
> EBADF to mean 'RM found invalid handle in message' is probably sane.
>
>> 2 - What's the TSS supposed to do with it?  I can return some generic
>> "problem in the TPM device driver".
>
> Depends on the midlayer I suppose. If it supports string error
> formatting it could decode EBADF to the string 'RM found invalid
> handle in message' for instance.

I'll try again with additional reasons:

- As much as possible, the RM should be transparent to the application. 
Returning a TPM return code in one case and a write() bad address in the 
other violates that.

- The TPM spec says to return TPM_RC_HANDLE.  This is what application 
developers will expect when they use an invalid handle.

- (No flames, please)  I asked Microsoft what they do in their resource 
manager.  They return TPM_RC_HANDLE.

- The TPM encodes information in the return code.  In this case 0x01c4 
says that parameter 1 is bad.  Returning an errno is a lose of valuable 
debug information.

- If you repurpose Bad Address to mean an invalid handle, what happens 
when there is really a bad address?

- EFAULT (bad address) is misleading.  A TPM handle is not an address.

- EBADF (bad file number) seems even more misleading.  What file?

- It's misleading.  A write() error should mean that the write to the 
TPM failed.  In this case, the RM didn't write, but says the write() failed.

- The "midlayer" is the lowest layer of the TSS, where it's writing raw 
byte streams.  It has no idea that there's a handle in the stream,
and replacing the error code is awkward.

- Libraries by default do not print strings.

- There's no guarantee that EBADF means "invalid handle".  I counted 17 
EFAULT uses, most low level driver errors.  The TSS could mislead the user.

Solution:

I suspect that the RM could just code:

	if (can't map the transient handle for this connection)
		map it to TPM_RH_NULL

and let the TPM do the rest.








------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
