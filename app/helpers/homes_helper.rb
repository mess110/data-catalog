module HomesHelper

  def activity_string(activity)
    subject = noun(activity.subject_label, activity.subject_path)
    verb = PAST_TENSE[activity.verb]
    object = noun(activity.object_label, activity.object_path)
    time = time_ago_in_words(activity.created_at) + ' ago'
    [subject, verb, object, time].compact.join(" ").html_safe
  end

  def noun(label, path)
    if label && path
      link_to(label, path)
    elsif label
      label
    elsif path
      link_to(path, path)
    end
  end

  PAST_TENSE = {
    'comment' => 'commented on',
    'follow'  => 'followed',
    'sign-up' => 'signed-up',
    'suggest' => 'suggested',
    'watch'   => 'watched',
  }

end
